//
//  DashboardCardViewModel.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/8/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

typealias LeaderboardInfo = (leaderboard: CustomLeaderboard?, region: String?, division: String?, error: Error?)

/// View model for a single dashboard card.
struct DashboardCardViewModel {

    /// User's ID.
    let userId: String

    /// User's division ID (either age-dependent or overall division).
    let divisionId: String

    /// User's region ID.
    let regionId: String?

    /// The user's affiliate ID.
    let affiliateId: String?

    /// Indicates if the leaderboard is for a particular affiliate and should be named accordingly.
    let isAffiliateLeaderboard: Bool

    let customNameFirstLine: String

    let customNameSecondLine: String?

    /// Page for the card.
    let page: Int?

    /// Total pages for a particular result set
    let totalPages: Int

    /// Athlete's rank
    let rank: String

    /// Total number of athlates
    let numberOfAthletes: Int?

    let year: String

    var backgroundImage: UIImage {
        if let division = Int(divisionId).flatMap({ APIDivision(rawValue: $0) }), regionId == nil && !isAffiliateLeaderboard {
            if division.isMale {
                return #imageLiteral(resourceName: "men")
            } else {
                return #imageLiteral(resourceName: "women")
            }
        } else if regionId != nil && !isAffiliateLeaderboard {
            return #imageLiteral(resourceName: "region")
        } else {
            return #imageLiteral(resourceName: "affiliate")
        }
    }

    /// Search condition for finding an athlete in their leaderboard.
    var searchCondition: LeaderboardSearchCondition {
        if let page = page, isAffiliateLeaderboard {
            return .page(pageIndex: page)
        } else {
            return .athlete(athleteId: userId)
        }
    }

    private let customName: String

    private let leaderboardFilterService: LeaderboardFilterService

    private let leaderboardListService: LeaderboardListService

    private let localization = DashboardLocalization()

    static func worldWideDivisionViewModel(personalizedLeaderboard: PersonalizedLeaderboard) -> DashboardCardViewModel? {
        guard isLatestPersonalizedLeaderboardRecentEnough(personalizedLeaderboard) else {
            return nil
        }

        guard let mostRecentCompetition = personalizedLeaderboard
            .mostRecentStartedOpenCompetition(using: ServiceFactory.shared.createCompetitionInfoService())
            ?? personalizedLeaderboard.mostRecentOpenCompetition else {
                return nil
        }

        let mostRecentWorldwideCompetition = mostRecentCompetition.worldWide
        return DashboardCardViewModel(userId: String(personalizedLeaderboard.competitorId),
                                      divisionId: String(mostRecentCompetition.divisionId),
                                      regionId: nil,
                                      affiliateId: nil,
                                      isAffiliateLeaderboard: false,
                                      customNameFirstLine: DashboardLocalization().worldwide,
                                      customNameSecondLine: mostRecentCompetition.divisionName,
                                      page: mostRecentCompetition.currentPage,
                                      totalPages: mostRecentWorldwideCompetition?.totalPages
                                        ?? mostRecentCompetition.totalPages // ONLY FOR WORLDWIDE we reach for a value
                                                                            // outside the single competition field. Still checking for
                                                                            // mostRecentWorldwideCompetition.totalPages in case that's
                                                                            // added in the future.
                                        ?? 0,
                                      rank: mostRecentWorldwideCompetition?.rank ?? "1",
                                      numberOfAthletes: numberOfAthletes(on: mostRecentWorldwideCompetition,
                                                                         totalPages: mostRecentWorldwideCompetition?.totalPages
                                                                            ?? mostRecentCompetition.totalPages),
                                      year: mostRecentCompetition.year,
                                      customName: DashboardLocalization().worldwide
                                        .appending("\n")
                                        .appending(mostRecentCompetition.divisionName),
                                      leaderboardFilterService: ServiceFactory.shared.createLeaderboardFilterService(),
                                      leaderboardListService: ServiceFactory.shared.createLeaderboardListService())
    }

    static func regionWideDivisionViewModel(personalizedLeaderboard: PersonalizedLeaderboard) -> DashboardCardViewModel? {
        guard isLatestPersonalizedLeaderboardRecentEnough(personalizedLeaderboard) else {
            return nil
        }

        guard let mostRecentCompetition = personalizedLeaderboard
            .mostRecentStartedOpenCompetition(using: ServiceFactory.shared.createCompetitionInfoService())
            ?? personalizedLeaderboard.mostRecentOpenCompetition else {
                return nil
        }

        guard let mostRecentRegionwideCompetition = mostRecentCompetition.byRegion else {
            return nil
        }

        guard let rank = mostRecentRegionwideCompetition.rank else {
            return nil
        }

        let personalizedLeaderboardService = ServiceFactory.shared
            .createPersonalizedLeaderboardService(userID: String(personalizedLeaderboard.competitorId))
        return DashboardCardViewModel(userId: String(personalizedLeaderboard.competitorId),
                                      divisionId: String(mostRecentCompetition.divisionId),
                                      regionId: (mostRecentRegionwideCompetition.id).flatMap(String.init),
                                      affiliateId: nil,
                                      isAffiliateLeaderboard: false,
                                      customNameFirstLine: mostRecentRegionwideCompetition.name
                                        ?? mostRecentRegionwideCompetition.regionName
                                        ?? "",
                                      customNameSecondLine: mostRecentCompetition.divisionName,
                                      page: mostRecentRegionwideCompetition.currentPage,
                                      totalPages: mostRecentRegionwideCompetition.totalPages ?? 0,
                                      rank: rank,
                                      numberOfAthletes: numberOfAthletes(on: mostRecentRegionwideCompetition,
                                                                         totalPages: mostRecentRegionwideCompetition.totalPages),
                                      year: mostRecentCompetition.year,
                                      customName: (mostRecentRegionwideCompetition.regionName ?? "")
                                        .appending("\n")
                                        .appending(mostRecentCompetition.divisionName),
                                      leaderboardFilterService: ServiceFactory.shared.createLeaderboardFilterService(),
                                      leaderboardListService: ServiceFactory.shared.createLeaderboardListService())
    }

    static func affiliateViewModel(personalizedLeaderboard: PersonalizedLeaderboard) -> DashboardCardViewModel? {
        guard isLatestPersonalizedLeaderboardRecentEnough(personalizedLeaderboard) else {
            return nil
        }

        guard let mostRecentCompetition = personalizedLeaderboard
            .mostRecentStartedOpenCompetition(using: ServiceFactory.shared.createCompetitionInfoService())
            ?? personalizedLeaderboard.mostRecentOpenCompetition else {
                return nil
        }

        guard let mostRecentAffiliateCompetition = mostRecentCompetition.byAffiliate else {
            return nil
        }

        guard let rank = mostRecentAffiliateCompetition.rank else {
            return nil
        }

        let personalizedLeaderboardService = ServiceFactory.shared
            .createPersonalizedLeaderboardService(userID: String(personalizedLeaderboard.competitorId))
        return DashboardCardViewModel(userId: String(personalizedLeaderboard.competitorId),
                                      divisionId: String(mostRecentCompetition.divisionId),
                                      regionId: nil,
                                      affiliateId: (mostRecentAffiliateCompetition.affiliateId).flatMap(String.init),
                                      isAffiliateLeaderboard: true,
                                      customNameFirstLine: mostRecentCompetition.affiliateName ?? "",
                                      customNameSecondLine: mostRecentCompetition.divisionName,
                                      page: mostRecentAffiliateCompetition.currentPage,
                                      totalPages: mostRecentAffiliateCompetition.totalPages ?? 0,
                                      rank: rank,
                                      numberOfAthletes: numberOfAthletes(on: mostRecentAffiliateCompetition,
                                                                         totalPages: mostRecentAffiliateCompetition.totalPages),
                                      year: mostRecentCompetition.year,
                                      customName: (mostRecentAffiliateCompetition.regionName ?? "")
                                        .appending("\n")
                                        .appending(mostRecentCompetition.divisionName),
                                      leaderboardFilterService: ServiceFactory.shared.createLeaderboardFilterService(),
                                      leaderboardListService: ServiceFactory.shared.createLeaderboardListService())
    }

    private static func numberOfAthletes(on competition: PersonalizedLeaderboardSingleCompetitionResult?, totalPages: Int?) -> Int? {
        return competition?.totalAthletes == 0 ? nil : competition?.totalAthletes
    }

    private static func isLatestPersonalizedLeaderboardRecentEnough(_ personalizedLeaderboard: PersonalizedLeaderboard) -> Bool {
        return isLatestPersonalizedLeaderboardLastYear(personalizedLeaderboard) || isLatestPersonalizedLeaderboardThisYear(personalizedLeaderboard)
    }

    private static func isLatestPersonalizedLeaderboardThisYear(_ personalizedLeaderboard: PersonalizedLeaderboard) -> Bool {
        let currentYear = Calendar.autoupdatingCurrent.component(Calendar.Component.year, from: Date())
        let mostRecentCompetitionResult = (personalizedLeaderboard.mostRecentOpenCompetitions.first?.year).flatMap(Int.init) ?? -1
        return mostRecentCompetitionResult == currentYear
    }

    private static func isLatestPersonalizedLeaderboardLastYear(_ personalizedLeaderboard: PersonalizedLeaderboard) -> Bool {
        let currentYear = Calendar.autoupdatingCurrent.component(Calendar.Component.year, from: Date())
        let mostRecentCompetitionResult = (personalizedLeaderboard.mostRecentOpenCompetitions.first?.year).flatMap(Int.init) ?? -1
        return mostRecentCompetitionResult == currentYear - 1
    }

    /// Loads a custom leaderboard.
    ///
    /// - Parameters:
    ///   - completion: Completion block that is called with the result of the view model.
    func load(completion: @escaping (CustomLeaderboard?, Error?) -> Void) {
        // First off, get leaderboard filters. This response might already be cached and return immediately.
        let filterRequest: (@escaping ([LeaderboardControls]?, Error?) -> Void) -> Void = leaderboardFilterService.getLeaderboardFilters

        // Apply those filters to fetch the first leaderboard.
        filterRequest { (controls, error) in
            let parsedLeaderboard = self.createLeaderboard(from: controls, error: error)

            guard let leaderboard = parsedLeaderboard.leaderboard else {
                completion(nil, parsedLeaderboard.error)
                return
            }

            completion(leaderboard, error)
        }
    }

    private func getLastPage(with leaderboard: CustomLeaderboard, pageIndex: Int, completion: @escaping (LeaderboardPage?, Error?) -> Void) {
        leaderboardListService.getLeaderboardList(with: leaderboard,
                                                  searchCondition: .page(pageIndex: pageIndex),
                                                  completion: completion)
    }

    /// Creates a custom leaderboard that matches the parameters set on `self`.
    ///
    /// - Parameters:
    ///   - controls: Leaderboard controls that have been loaded from the API.
    ///   - error: Error from the API.
    /// - Returns: Response translated into a custom leaderboard, passing in information that is contained in filters, such as division
    ///   and region name, injected with parameters set on `self`.
    private func createLeaderboard(from controls: [LeaderboardControls]?, error: Error?) -> LeaderboardInfo {
        guard let controls = controls, error == nil else {
            return (nil, nil, nil, error)
        }

        // Get only open competitions
        guard let selectedControls = controls.filter({ (controls) -> Bool in
            controls.type == Competition.open.searchQueryString
            // Sort them by year (descending, to get the most current year first)
        }).sorted(by: { (lhs, rhs) -> Bool in
            lhs.year.compare(rhs.year) == ComparisonResult.orderedDescending
            // And select the first controls (most current open).
        }).first(where: { $0.year == self.year }) else {
            print("Failed to get most current open. In: \(#file), line: \(#line)")
            return (nil, nil, nil, error)
        }

        var filterSelection: [LeaderboardFilterSelection] = []
        var regionName: String?
        var divisionName: String?

        // MARK: - v2 Filter data format

        // First, apply a filter for the fittest selection (aka: region).
        // Grab the "fittest" filter.
        if let fittestFilter = selectedControls.controls.first(where: { (filter) -> Bool in
            filter.configName == FilterName.fittestIn.rawValue
            // Get the "region" filter.
        }), let regionFilter = fittestFilter.data.first(where: { (data) -> Bool in
            // 1 is equivalent to the region.
            data.value == "1"
            // Get the "region" selection.
        }) as? MultiselectLeaderboardFilterData, let regionSelection = regionFilter.selects.first(where: { (selection) -> Bool in
            selection.value == self.regionId ?? "0"
        }) {
            regionName = regionSelection.display
            filterSelection.append(LeaderboardFilterSelection.multiSelect(filter: fittestFilter,
                                                                          selection: regionFilter,
                                                                          nestedSelection: regionSelection))
        }

        // MARK: - v3 Filter data format

        else if let fittestFilter = selectedControls.controls.first(where: { (filter) -> Bool in
            filter.configName == FilterName.region.rawValue
        }), let regionFilter = fittestFilter.data.first(where: { (data) -> Bool in
            data.value == FilterName.region.rawValue
        }) as? RegionSelectionFilterData, let selectedRegion = regionFilter.regions.first(where: { (data) -> Bool in
            data.value == self.regionId ?? "0"
        }) {
            regionName = selectedRegion.display
            filterSelection.append(LeaderboardFilterSelection.regionSelect(filter: fittestFilter,
                                                                           selection: regionFilter,
                                                                           region: selectedRegion,
                                                                           nestedRegion: nil))
        }

        /// Next, apply a filter for the division.
        if let divisionFilter = selectedControls.controls.first(where: { (filter) -> Bool in
            filter.configName == FilterName.division.rawValue
            // Make a division selection matching the user's division ID.
        }), let divisionSelection = divisionFilter.data.first(where: { (data) -> Bool in
            data.value == self.divisionId
        }) {
            divisionName = divisionSelection.display
            filterSelection.append(LeaderboardFilterSelection.defaultSelection(filter: divisionFilter, selection: divisionSelection))
        }

        let leaderboard = CustomLeaderboard(controls: controls,
                                            filterSelection: filterSelection,
                                            selectedControls: selectedControls,
                                            affiliate: isAffiliateLeaderboard ? self.affiliateId : nil)

        return (leaderboard, regionName, divisionName, error)
    }

}
