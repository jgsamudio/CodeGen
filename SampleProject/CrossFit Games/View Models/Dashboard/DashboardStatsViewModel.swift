//
//  DashboardStatsViewModel.swift
//  CrossFit Games
//
//  Created by Malinka S on 11/13/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// View model for the Dash board stats view
class DashboardStatsViewModel {

    // MARK: - Public Properties
    
    let dashboardCardViewModel: DashboardCardViewModel

    // MARK: - Private Properties
    
    private let leaderboardFilterService: LeaderboardFilterService = ServiceFactory.shared.createLeaderboardFilterService()

    private let leaderboardListService: LeaderboardListService = ServiceFactory.shared.createLeaderboardListService()

    private let competitionInfoService: CompetitionInfoService = ServiceFactory.shared.createCompetitionInfoService()

    private(set) var isLoading: Bool = false

    private(set) var didLoad: Bool = false

    /// User's ID.
    var userId: String {
        return dashboardCardViewModel.userId
    }

    /// User's division ID (either age-dependent or overall division).
    var divisionId: String {
        return dashboardCardViewModel.divisionId
    }

    /// User's region ID.
    var regionId: String? {
        return dashboardCardViewModel.regionId
    }

    /// The user's affiliate ID.
    var affiliateId: String? {
        return dashboardCardViewModel.affiliateId
    }

    /// Workout Types
    private(set) var workoutTypes: [String] = []

    private(set) var workoutStats: [WorkoutStatsViewModel] = []

    /// Returns the number of scored workouts.
    var numberOfScoredWorkouts: Int {
        return workoutStats.filter {
            !$0.workoutScore.isEmpty
        }.count
    }

    /// overall rank of the athlete
    var overallRank: String {
        return formatNumberToDecimalStyle(value: Int(dashboardCardViewModel.rank) ?? 1)
    }

    /// Maximum rank in the division
    var maximumRank: String? {
        if let numberOfAthletes = maximumRankValue {
            return formatNumberToDecimalStyle(value: numberOfAthletes)
        }
        return nil
    }

    /// Numeric value for the maximum rank.
    var maximumRankValue: Int? {
        return dashboardCardViewModel.numberOfAthletes
    }

    /// Percentile value which includes the suffix (st, th, nd rd)
    var percentileTextValue: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        guard let percentileValue = percentileValue else {
            return nil
        }
        return numberFormatter.string(from: NSNumber(value: percentileValue)) ?? ""
    }

    /// Indicates whether the Open is currently active.
    var isOpenActive: Bool {
        let result = competitionInfoService.activeCompetitions.contains(where: {
            $0.0 == Competition.open.searchQueryString
        })

        return result
    }

    /// Returns the year of the next Open competition (if any are upcoming)
    var nextOpenYear: String? {
        // Get only Open competitions
        let result = competitionInfoService.allCompetitions.filter({ (pair) -> Bool in
            pair.0 == Competition.open.searchQueryString
            // Get start date for the pair for filtering, e.g. (Open, 2018) -> (Open, 2018, 01/01/2018)
        }).flatMap({ (pair) -> (String, String, Date)? in
            guard let date = competitionInfoService.startDate(for: pair.0, in: pair.1) else { return nil }
            return (pair.0, pair.1, date)
            // Sort by start date in ascending order
        }).sorted(by: { (a, b) -> Bool in
            return a.2 < b.2
            // Get the first competition that is in the future
        }).first(where: { (elem) -> Bool in
            elem.2 > DatePicker.shared.date
            // Get the year of that competition
        })?.1

        return result
    }

    /// Percentile value of an athlete
    private(set) var percentileValue: Int?

    /// Styleable row for percentile
    var styleableRowForPercentile: StyleRow {
        if let percentileValue = percentileValue {
            if percentileValue >= 100000 {
                return .r9
            } else if percentileValue < 100000 && percentileValue >= 10000 {
                return .r14
            }
        }
        return .r15
    }

    var title: String {
        return dashboardCardViewModel.customNameFirstLine
            .appending(dashboardCardViewModel.customNameSecondLine.flatMap {"\n\($0)"} ?? "")
    }

    // MARK: - Initialization
    
    init(dashboardCardViewModel: DashboardCardViewModel) {
        self.dashboardCardViewModel = dashboardCardViewModel
    }

    // MARK: - Public Functions
    
    func loadIfNeeded(completion: @escaping (Error?) -> Void) {
        if isLoading || didLoad {
            return
        }

        isLoading = true

        dashboardCardViewModel.load { [weak self] (leaderboard, error) in
            guard let leaderboard = leaderboard, let userId = self?.userId else {
                self?.isLoading = false
                self?.didLoad = true
                completion(error)
                return
            }

            self?.leaderboardListService
                .getLeaderboardList(with: leaderboard,
                                    searchCondition: self?.dashboardCardViewModel.searchCondition ?? .athlete(athleteId: userId),
                                    completion: { (page, error) in
                                        guard let page = page else {
                                            self?.isLoading = false
                                            self?.didLoad = true
                                            completion(error)
                                            return
                                        }

                                        guard let athleteItem = page.items.first(where: { (listItem) -> Bool in
                                            listItem.user.userId == self?.userId
                                        }) else {
                                            self?.isLoading = false
                                            self?.didLoad = true
                                            CrashlyticsIntegration.shared.log(event: .didNotFindUserForDashboardStats)
                                            completion(LeaderboardSearchError.athleteNotFound)
                                            return
                                        }

                                        self?.getAthleteCount(afterLoading: page,
                                                              on: leaderboard,
                                                              completion: { (athleteCount) in
                                                                self?.workoutTypes = page.ordinals.map { $0.id }
                                                                let ordinals = page.ordinals

                                                                let workoutScores = athleteItem.scores

                                                                var workoutStatsViewModels: [WorkoutStatsViewModel] = []
                                                                ordinals.forEach({ ordinal in
                                                                    guard let workoutScore = (workoutScores.filter {
                                                                        $0.ordinalID == ordinal.id
                                                                        }.first), let rank = Int(workoutScore.workoutRank) else {
                                                                            return
                                                                    }

                                                                    workoutStatsViewModels.append(WorkoutStatsViewModel(
                                                                        workoutDisplayName: ordinal.displayName,
                                                                        rank: workoutScore.workoutRank,
                                                                        percentileValue: percentile(rank: rank,
                                                                                                    maxRank: athleteCount),
                                                                        workoutScore: workoutScore.scoreDisplay,
                                                                        workoutTypeId: workoutScore.ordinalID)
                                                                    )
                                                                })

                                                                self?.workoutStats = workoutStatsViewModels
                                                                let rank = (self?.dashboardCardViewModel.rank).flatMap(Int.init) ?? 1
                                                                self?.percentileValue = percentile(rank: rank,
                                                                                                   maxRank: athleteCount)

                                                                self?.isLoading = false
                                                                self?.didLoad = true
                                                                completion(nil)
                                        })
                })
        }
    }

    /// Navigates to the leaderboard shown in `self`.
    ///
    /// - Parameter tabBarController: Tab bar controller used to switch tabs appropriately.
    func navigateToLeaderboard(pushIn navigationController: UINavigationController?) {
        let cardViewModel = dashboardCardViewModel
        let affiliate = affiliateId
        dashboardCardViewModel.load { (leaderboard, _) in
            guard let leaderboard = leaderboard else {
                return
            }

            LeaderboardPresentationRouter.pushingIn(navigationController: navigationController,
                                                    title: cardViewModel.customNameFirstLine,
                                                    subtitle: cardViewModel.customNameSecondLine,
                                                    isAffiliateLeaderboard: affiliate != nil)
                .present(leaderboard: leaderboard,
                         searchingAthlete: cardViewModel.userId,
                         onPage: cardViewModel.isAffiliateLeaderboard ? cardViewModel.page : nil)
        }
    }

    /// Gets the athlete count on the given leaderboard.
    ///
    /// - Parameters:
    ///   - page: Leaderboard page to evaluate whether additional API calls are needed and get total number of pages.
    ///   - leaderboard: Leaderboard to search in.
    ///   - completion: Completion block which is called with the number of athletes.
    private func getAthleteCount(afterLoading page: LeaderboardPage, on leaderboard: CustomLeaderboard, completion: @escaping (Int) -> Void) {
        // Only go crazy on athlete count if we're not looking at the last page anyways ...
        guard page.pageIndex < page.totalPageCount
            // ... and the number of athletes is not given ...
            && dashboardCardViewModel.numberOfAthletes == nil
            // ... and we're talking about an affiliate leaderboard. ...
            && dashboardCardViewModel.isAffiliateLeaderboard else {
                // ... otherwise, return either the number of athletes that was given or
                // the current (= last) page's item count + page size * rest of pages.
                completion(dashboardCardViewModel.numberOfAthletes
                    ?? (page.items.count + (page.totalPageCount - 1) * LeaderboardListService.pageSize))
                return
        }

        leaderboardListService
            .getLeaderboardList(with: leaderboard,
                                searchCondition: .page(pageIndex: page.totalPageCount)) { (lastPage, error) in
                                    guard let lastPage = lastPage, error == nil else {
                                        completion(page.totalPageCount * LeaderboardListService.pageSize)
                                        return
                                    }

                                    completion(lastPage.items.count + (lastPage.pageIndex - 1) * LeaderboardListService.pageSize)
        }
    }

    private func formatNumberToDecimalStyle(value: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: value)) ?? ""
    }

    /// Creates a custom leaderboard that matches the parameters set on `self`.
    ///
    /// - Parameters:
    ///   - controls: Leaderboard controls that have been loaded from the API.
    ///   - error: Error from the API.
    /// - Returns: Response translated into a custom leaderboard, passing in information that is contained in filters, such as division
    ///   and region name, injected with parameters set on `self`.
    private func createLeaderboard(from controls: [LeaderboardControls]?, and workoutType: String, error: Error?) -> LeaderboardInfo {
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
        }).first else {
            print("Failed to get most current open. In: \(#file), line: \(#line)")
            return (nil, nil, nil, error)
        }

        var filterSelection: [LeaderboardFilterSelection] = []
        var regionName: String?
        var divisionName: String?

        // First, apply a filter for the fittest selection (aka: region).
        // Grab the "fittest" filter.
        if let fittestFilter = selectedControls.controls.first(where: { (filter) -> Bool in
            filter.configName == "fittest"
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

        /// Next, apply a filter for the division.
        if let divisionFilter = selectedControls.controls.first(where: { (filter) -> Bool in
            filter.configName == "division"
            // Make a division selection matching the user's division ID.
        }), let divisionSelection = divisionFilter.data.first(where: { (data) -> Bool in
            data.value == self.divisionId
        }) {
            divisionName = divisionSelection.display
            filterSelection.append(LeaderboardFilterSelection.defaultSelection(filter: divisionFilter, selection: divisionSelection))
        }

        /// Next, apply a filter for the division.
        if let sortFilter = selectedControls.controls.first(where: { (filter) -> Bool in
            filter.configName == "sort"
            // Make a division selection matching the user's division ID.
        }), let sortSelection = sortFilter.data.first(where: { (data) -> Bool in
            data.value == workoutType
        }) {
            filterSelection.append(LeaderboardFilterSelection.defaultSelection(filter: sortFilter, selection: sortSelection))
        }

        let leaderboard = CustomLeaderboard(controls: controls,
                                            filterSelection: filterSelection,
                                            selectedControls: selectedControls,
                                            affiliate: self.affiliateId)

        return (leaderboard, regionName, divisionName, error)
    }
}
