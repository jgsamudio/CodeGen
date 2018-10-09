//
//  DashboardViewModel.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/8/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

private typealias DashboardUserInfo = (userId: String,
    divisionId: String,
    divisionName: String,
    ageDivisionId: String?,
    affiliateId: String?,
    regionId: String?)

/// View model for the dashboard screen, used to load sub view models for each of the dashboard cards.
struct DashboardViewModel {

    // MARK: - Private Properties
    
    private let userAuthService: UserAuthService
    private var leaderboardService: PersonalizedLeaderboardService?
    private let localization = DashboardLocalization()
    private let competitionInfoService: CompetitionInfoService
    private let leaderboardFilterService: LeaderboardFilterService
    private let remoteConfigService: RemoteConfigService
    private let followAnAthleteService: FolllowAnAthleteService
    private let leaderboardListService: LeaderboardListService

    // MARK: - Public Properties
    
    /// URL to register for Open events
    let openRegistrationURL = URL(string: "https://games.crossfit.com/register/open")

    /// App share URL
    let appShareURL = URL(string: "https://itunes.apple.com/us/app/crossfit-games/id825019869?ls=1&mt=8")

    /// Account Title
    var accountTitle: String? {
        let datastore = userAuthService.userDataStore
        return datastore.isLoggedIn ? datastore.userFullname : localization.accountYour
    }

    /// Account Subtitle
    var accountSubtitle: String? {
        let isLoggedIn = userAuthService.userDataStore.isLoggedIn
        return isLoggedIn ? localization.accountWelcome : localization.accountLogin
    }

    /// Determines if user is currently logged in
    var isLoggedIn: Bool {
        return userAuthService.userDataStore.isLoggedIn
    }

    /// Indicates whether the user is registered for the currently active Open competition.
    var canRegisterForOpen: Bool {
        return competitionInfoService.canRegisterForActiveOpen
    }

    /// Indicates whether the retrieved personalized leaderboard was invalid.
    var isPersonalizedLeaderboardInvalid = false

    // MARK: - Initialization
    
    init(userAuthService: UserAuthService,
         leaderboardService: PersonalizedLeaderboardService?,
         competitionInfoService: CompetitionInfoService,
         leaderboardFilterService: LeaderboardFilterService,
         remoteConfigService: RemoteConfigService,
         followAnAthleteService: FolllowAnAthleteService,
         leaderboardListService: LeaderboardListService) {
        self.userAuthService = userAuthService
        self.leaderboardService = leaderboardService
        self.competitionInfoService = competitionInfoService
        self.leaderboardFilterService = leaderboardFilterService
        self.remoteConfigService = remoteConfigService
        self.followAnAthleteService = followAnAthleteService
        self.leaderboardListService = leaderboardListService
    }

    init() {
        let userAuthService = ServiceFactory.shared.createUserAuthService()
        let leaderboardListService: LeaderboardListService = ServiceFactory.shared.createLeaderboardListService()
        var leaderboardService: PersonalizedLeaderboardService?
        if let userID = userAuthService.userDataStore.detailedUser?.userId {
            leaderboardService = ServiceFactory.shared.createPersonalizedLeaderboardService(userID: userID)
        }
        self.init(userAuthService: userAuthService,
                  leaderboardService: leaderboardService,
                  competitionInfoService: ServiceFactory.shared.createCompetitionInfoService(),
                  leaderboardFilterService: ServiceFactory.shared.createLeaderboardFilterService(),
                  remoteConfigService: ServiceFactory.shared.createRemoteConfigService(),
                  followAnAthleteService: ServiceFactory.shared.createFollowAnAthleteService(),
                  leaderboardListService: leaderboardListService)
    }

    // MARK: - Public Functions
    
    /// Gets the information of the following athlete
    ///
    /// - Parameter completion: Completion block which includes the following athlete view model and the error
    ///     if occurs
    func getFollowingAthlete(completion: @escaping (DashboardFollowAnAthleteViewModel?, Error?) -> Void) {
        if let followAnAthleteId = followAnAthleteService.getFollowingAthleteId() {
            followAnAthleteService.getFollowingAthleteDashboardViewModel(by: followAnAthleteId, completion: completion)
        } else {
            completion(nil, nil)
        }
    }

    /// Refreshes the cache for the relevant leaderboard URL/athlete
    func refreshFollowingAthleteCache() {
        followAnAthleteService.refresh()
    }

    /// Retrieve personalized leaderboard information
    ///
    /// - Parameter completion: Closure that will be called whenever API information has returned
    func retrievePersonalizedLeaderboard(completion: @escaping ([DashboardCardViewModel]?, PersonalizedLeaderboard?, Error?) -> Void) {
        guard let leaderboardService = leaderboardService else {
            completion([], nil, nil)
            return
        }
        leaderboardService.retrievePersonalized { (personalizedLeaderboard, error) in
            guard error == nil else {
                completion(nil, nil, error)
                return
            }

            if let personalizedLeaderboard = personalizedLeaderboard {
                self.competitionInfoService.update(using: personalizedLeaderboard)
            }

            self.getLeaderboardFiltersIfNeeded(completion: { (error) in
                guard error == nil else {
                    completion(nil, nil, error)
                    return
                }

                // MARK: - Load dashboard cards
                if let personalizedLeaderboard = personalizedLeaderboard {
                    // First dashboard card: Worldwide, Division
                    let viewModels: [DashboardCardViewModel] = [
                        DashboardCardViewModel.worldWideDivisionViewModel(personalizedLeaderboard: personalizedLeaderboard),
                        DashboardCardViewModel.regionWideDivisionViewModel(personalizedLeaderboard: personalizedLeaderboard),
                        DashboardCardViewModel.affiliateViewModel(personalizedLeaderboard: personalizedLeaderboard)
                        ].flatMap { $0 }

                    completion(viewModels, personalizedLeaderboard, nil)
                } else {
                    completion(nil, nil, error)
                }
            })
        }
    }

    /// Gets the promo items to show in the UI.
    ///
    /// - Parameters:
    ///   - completion: Completion block which is called with the response.
    func getPromoItems(completion: @escaping ([RemoteConfigPromoItem]) -> Void) {
        remoteConfigService.fetch { (config, error) in
            guard error == nil else {
                return
            }

            completion(config?.promoItems ?? [])
        }
    }

    /// Gets leaderboard filters if not done before in order to update locally saved competition information.
    /// This information is needed to indicate whether a certain event has started yet or not.
    /// (see: PersonalizedLeaderboard.mostRecentStartedOpenCompetition(using _: CompetitionInfoService))
    ///
    /// - Parameters:
    ///   - personalizedLeaderboard: Personalized leaderboard that are to be checked.
    ///   - completion: Completion block that is called once competition information has been updated.
    private func getLeaderboardFiltersIfNeeded(completion: @escaping (Error?) -> Void) {
        leaderboardFilterService.getLeaderboardFilters { (controls, error) in
            guard let controls = controls, error == nil else {
                completion(error)
                return
            }

            self.competitionInfoService.update(using: controls)
            completion(nil)
        }
    }

    private func regionDivisionName(leaderboardControls: LeaderboardControls, divisionId: String, regionName: String?) -> String {
        return [regionName,
                FilterOptionName(id: divisionId,
                                 filterName: FilterName.division,
                                 leaderboardControls: leaderboardControls).description].flatMap { $0 }.joined(separator: " ")
    }

}
