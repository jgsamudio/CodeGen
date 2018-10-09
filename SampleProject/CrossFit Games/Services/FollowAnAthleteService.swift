//
//  FollowAnAthleteService.swift
//  CrossFit Games
//
//  Created by Malinka S on 2/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Contains the functions regarding following an athlete
struct FolllowAnAthleteService {

    private var leaderboardListService: LeaderboardListService

    init() {
        leaderboardListService = ServiceFactory.shared.createLeaderboardListService()
    }

    /// Saves the athlete id which would be follown
    ///
    /// - Parameter viewModel: LeaderboardAthleteResultCellViewModel
    func followAthlete(with viewModel: LeaderboardAthleteResultCellViewModel) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(viewModel) {
            UserDefaultsManager.shared.setValue(withKey: .followingAthleteViewModel, value: encoded)
        }
    }

    /// Unfollows the current following athlete by clearing user defaults
    func unFollowAthlete() {
        UserDefaultsManager.shared.setValue(withKey: .followingAthleteViewModel, value: nil)
    }

    /// Gets the following athlete id
    ///
    /// - Returns: Athlete id
    func getFollowingAthleteId() -> String? {
        if let athlete = getFollowingAthleteViewModel() {
            return athlete.id
        }
        return nil
    }

    /// Saves the custom leaderboard, based on the selected filters
    ///
    /// - Parameter customLeaderboard: Custom leaderboard
    func saveCustomLeaderboardForAthlete(customLeaderboard: CustomLeaderboard) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(customLeaderboard) {
            UserDefaultsManager.shared.setValue(withKey: .followingAthleteCustomLeaderboard, value: encoded)
        }
    }

    /// Returns the saved custom leaderboard
    ///
    /// - Returns: Custom leaderboard instance
    func getSavedCustomLeaderboard() -> CustomLeaderboard? {
        if let customLeaderboardData = UserDefaultsManager.shared.getData(byKey: .followingAthleteCustomLeaderboard) {
            let decoder = JSONDecoder()
            return try? decoder.decode(CustomLeaderboard.self, from: customLeaderboardData)
        }
        return nil
    }

    /// Refreshes the results cached for the same path as the current active leaderboard.
    func refresh() {
        if let customLeaderboard = getSavedCustomLeaderboard() {
            let request = LeaderboardRequest(customLeaderboard: customLeaderboard)
            let clearCacheCondition: (URLRequest) -> Bool = { value in
                request.rawValue.urlRequest?.url?.pathComponents.elementsEqual(value.url?.pathComponents ?? []) == true
            }

            CFCache.default.reset(where: clearCacheCondition)
        }
    }

    /// Returns the saved view model
    ///
    /// - Returns: ViewModel instance
    func getFollowingAthleteViewModel() -> LeaderboardAthleteResultCellViewModel? {
        if let viewModelData = UserDefaultsManager.shared.getData(byKey: .followingAthleteViewModel) {
            let decoder = JSONDecoder()
            return try? decoder.decode(LeaderboardAthleteResultCellViewModel.self, from: viewModelData)
        }
        return nil
    }

    /// Gets the information of the following athlete
    ///
    /// - Parameters:
    ///   - followAthleteId: Athlete Id
    ///   - completion: Completion block which includes the following athlete view model and the error
    ///     if occurs
    func getFollowingAthleteDashboardViewModel(by followAthleteId: String,
                                               completion: @escaping (DashboardFollowAnAthleteViewModel?, Error?) -> Void) {
        if var customLeaderboard = getSavedCustomLeaderboard() {

            /// Only the division is used as filters
            var filterSelections: [LeaderboardFilterSelection] = []
            var selectedDivision: String?
            if let divisionSelection = customLeaderboard.filterSelection.first (where: { $0.filter.configName == "division" }) {
                filterSelections.append(divisionSelection)
                selectedDivision = divisionSelection.selection.display
            }

            /// Only for regionals, the region id used as a filter
            if customLeaderboard.selectedControls.type == Competition.regionals.searchQueryString,
                let regionalSelection = customLeaderboard.filterSelection.first (where: { $0.filter.configName == "regional" }) {
                filterSelections.append(regionalSelection)
            }

            customLeaderboard.filterSelection = filterSelections
            /// Remove affiliate from the leadeboard
            customLeaderboard.affiliate = nil

            var searchCondition: LeaderboardSearchCondition = .athlete(athleteId: followAthleteId)

            if customLeaderboard.selectedControls.type == Competition.games.searchQueryString ||
                customLeaderboard.selectedControls.type == Competition.regionals.searchQueryString {
                searchCondition = .page(pageIndex: 1)
            }

            leaderboardListService.getLeaderboardList(with: customLeaderboard,
                                                      searchCondition: searchCondition,
                                                      completion: { (page, error) in
                                                        if error != nil {
                                                            completion(nil, error)
                                                        }
                                                        guard let page = page else {
                                                            completion(nil, nil)
                                                            return
                                                        }
                                                        let totalAthleteCount = page.totalNumberOfAthletes == 0 ?
                                                            page.totalPageCount * LeaderboardListService.pageSize :
                                                            page.totalNumberOfAthletes

                                                        if let athleteItem = page.items.first(where: { return $0.user.userId == followAthleteId }) {

                                                            let followAnAthleteViewModel =
                                                                DashboardFollowAnAthleteViewModel(
                                                                    id: athleteItem.user.userId,
                                                                    name: athleteItem.user.name,
                                                                    workouts: athleteItem.scores,
                                                                    imageUrl: athleteItem.user.profilePic,
                                                                    division: selectedDivision,
                                                                    totalAthleteCount: totalAthleteCount,
                                                                    rank: athleteItem.user.rank,
                                                                    ordinals: page.ordinals)
                                                            completion(followAnAthleteViewModel, nil)
                                                        } else {
                                                            completion(nil,
                                                                       LeaderboardSearchError.athleteDoesntExist(
                                                                        description:
                                                                        "Athlete Id: \(followAthleteId)")
                                                            )
                                                        }
            })
        } else {
            completion(nil, nil)
        }
    }
    
}
