//
//  LeaderboardResultViewModel.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/2/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// View model for the leaderboard result screen.
struct LeaderboardResultViewModel {

    // MARK: - Private Properties
    
    private let localization = LeaderboardLocalization()

    // MARK: - Public Properties
    
    /// Number of lines in the results.
    var numberOfLines: Int {
        guard let customLeaderboard = customLeaderboard else {
            return 0
        }

        return leaderboardListService.numberOfAthletes(for: customLeaderboard) ?? 0
    }

    /// Selected division name.
    var divisionName: String? {
        return (customLeaderboard?.filterSelection.first(where: { (selection) -> Bool in
            let configName = selection.filter.configName
            let division = FilterName.division.rawValue
            return configName == division
        })).flatMap({ (selection) -> String? in
            selection.selection.display
        })
    }

    /// Indicates whether the number of lines depicts a valid number of athletes or whether the number of athletes has yet to be loaded.
    var isValidNumberOfAthletesAvailable: Bool {
        return customLeaderboard.flatMap(leaderboardListService.numberOfAthletes) != nil
    }

    /// Current following athlete id
    var followingAthleteId: String? {
        return followAnAthleteService.getFollowingAthleteId()
    }

    /// Prefetch controller for the table view.
    let prefetchController: LeaderboardResultPrefetchController?

    /// A maximum number of lines which can be set once the last page was loaded.
    var maxNumberOfLines: Int?

    private let leaderboardListService: LeaderboardListService
    private let followAnAthleteService: FolllowAnAthleteService

    let customLeaderboard: CustomLeaderboard?

    // MARK: - Initialization
    
    init(leaderboardListService: LeaderboardListService, customLeaderboard: CustomLeaderboard?,
         followAnAthleteService: FolllowAnAthleteService) {
        self.leaderboardListService = leaderboardListService
        self.followAnAthleteService = followAnAthleteService
        self.customLeaderboard = customLeaderboard

        if let customLeaderboard = customLeaderboard {
            prefetchController = LeaderboardResultPrefetchController(leaderboard: customLeaderboard, leaderboardListService: leaderboardListService)
        } else {
            prefetchController = nil
        }
    }

    init(customLeaderboard: CustomLeaderboard?) {
        self.init(leaderboardListService: ServiceFactory.shared.createLeaderboardListService(),
                  customLeaderboard: customLeaderboard,
                  followAnAthleteService: ServiceFactory.shared.createFollowAnAthleteService())
    }
    
    // MARK: - Public Functions
    
    /// Determines if the view model contains enough information to render within UI. If so, returns a `LeaderboardAthleteResultCellViewModel`
    ///
    /// - Parameter indexPath: IndexPath to try displaying information
    /// - Returns: LeaderboardAthleteResultCellViewModel if enough information exists for view model
    func presentableViewModel(for indexPath: IndexPath) -> LeaderboardAthleteResultCellViewModel? {
        guard let listViewModel = listItemViewModel(at: indexPath.row) else {
            return nil
        }
        if let name = listViewModel.name, name.count > 0 {
            return listViewModel
        }
        return nil
    }

    /// Retrieves a leaderboard list page with the given index (default: 1)
    ///
    /// - Parameters:
    ///   - athleteId: Athlete ID to search for (if not nil, the response will contain the index path of the athlete's cell).
    ///   - completion: Completion block that is called with any errors that may have occurred.
    func retrieveLeaderboardList(searchingFor athleteId: String? = nil,
                                 onPage page: Int?,
                                 completion: @escaping (IndexPath?, Error?) -> Void) {
        guard let customLeaderboard = customLeaderboard else {
            return
        }

        leaderboardListService.getLeaderboardList(with: customLeaderboard,
                                                  searchCondition: page.flatMap {
                                                        LeaderboardSearchCondition.page(pageIndex: $0)
                                                    } ?? athleteId.flatMap {
                                                        LeaderboardSearchCondition.athlete(athleteId: $0)
                                                    } ?? .page(pageIndex: 1)) { (page, error) in
                                                        // Check if the athlete is on the page (if not nil). If so, return the athlete's index path.
                                                        if let page = page, let index = page.items.index(where: { (item) -> Bool in
                                                            item.user.userId == athleteId
                                                        }) {
                                                            let row = (page.pageIndex - 1) * LeaderboardListService.pageSize + index
                                                            let indexPath = IndexPath(row: row,
                                                                                      section: 0)
                                                            completion(indexPath, error)
                                                        } else {
                                                            completion(nil, error)
                                                        }
        }
    }

    /// Retrieves a list item view model for the athlete result cell at the given index.
    ///
    /// - Parameter index: Index of the cell.
    /// - Returns: View model for the cell at the given index.
    func listItemViewModel(at index: Int) -> LeaderboardAthleteResultCellViewModel? {
        guard let customLeaderboard = customLeaderboard else {
            return nil
        }

        let listItem = leaderboardListService.athlete(for: customLeaderboard, atIndex: index)

        let imageUrls = [0, 1].flatMap { (athleteIndex) -> URL? in
            return athleteImageUrl(at: index, athlete: athleteIndex)
        }

        let leaderboardPage = leaderboardListService.page(for: index, in: customLeaderboard)

        let ordinals = listItem?.scores.flatMap({ (score) -> LeaderboardOrdinal? in
            guard let leaderboardPage = leaderboardPage else {
                return nil
            }

            return leaderboardListService.ordinal(for: score, inLeaderboard: customLeaderboard, onPage: leaderboardPage.pageIndex)
        })

        var displayScore = (listItem?.user.points).flatMap(localization.points)
        if let sortFilterSelection = customLeaderboard.filterSelection.first(where: { (selection) -> Bool in
            selection.filter.configName == FilterName.sort.rawValue
        }), sortFilterSelection.selection.value != "0" {
            displayScore = listItem?.scores.first(where: { (score) -> Bool in
                score.ordinalID == sortFilterSelection.selection.value
            })?.scoreDisplay ?? displayScore
        }

        let availableScoreIndices = listItem?.scores.enumerated().filter({ (item) -> Bool in
            !item.element.scoreDisplay.isEmpty
        }).map { $0.offset } ?? []

        return LeaderboardAthleteResultCellViewModel(id: listItem?.user.userId ?? "",
                                                    name: athleteName(at: index),
                                                     imageUrls: imageUrls,
                                                     age: listItem?.user.age.flatMap(String.init),
                                                     region: listItem?.user.region,
                                                     rank: listItem?.user.rank,
                                                     height: listItem?.user.height,
                                                     weight: listItem?.user.weight,
                                                     points: listItem?.user.points,
                                                     workoutNames: ordinals?.enumerated().flatMap {
                                                        if availableScoreIndices.isEmpty && $0.offset == 0 {
                                                            return "-"
                                                        } else {
                                                            return availableScoreIndices.contains($0.offset)
                                                                ? $0.element.displayName : nil
                                                        }
                                                        } ?? [],
                                                     ranks: listItem?.scores.enumerated().flatMap {
                                                        if availableScoreIndices.isEmpty && $0.offset == 0 {
                                                            return "-"
                                                        } else {
                                                            return availableScoreIndices.contains($0.offset)
                                                                ? $0.element.workoutRank : nil
                                                        }
                                                        }.map(rank) ?? [],
                                                     scores: listItem?.scores.enumerated().flatMap {
                                                        if availableScoreIndices.isEmpty && $0.offset == 0 {
                                                            return "-"
                                                        } else {
                                                            return availableScoreIndices.contains($0.offset)
                                                                ? $0.element.scoreDisplay : nil
                                                        }
                                                        } ?? [],
                                                     displayScore: displayScore)
    }

    /// Creates a string based on the selected (default and nested) filters
    ///
    /// - Returns: a string specyfying filters
    func getSelectedFilters(includeSort: Bool = true) -> String {
        var filterSelection: String = customLeaderboard?.selectedControls.name ?? ""
        var sortedBy: String = ""
        
        customLeaderboard?.filterSelection.sorted(by: { (object1, object2) in
            object1.filter.configName > object2.filter.configName
        }).forEach({ leaderboardFilterSelection in
            switch leaderboardFilterSelection {
            case .defaultSelection( let filter, let selection):
                if filter.configName == FilterName.division.rawValue {
                    filterSelection += " \(selection.display)"
                } else if filter.configName == FilterName.sort.rawValue && selection.value != "0" && includeSort {
                    sortedBy = "\n\(localization.sortedBy) \(selection.display)"
                }
            case .regionSelect(filter: let filter, selection: _, region: let region, nestedRegion: let nestedRegion):
                if filter.configName == FilterName.region.rawValue {
                    if let nestedRegion = nestedRegion {
                        filterSelection += " \(nestedRegion.display)"
                    } else {
                        filterSelection += " \(region.display)"
                    }
                }
            case .multiSelect( _, _, let nestedSelection):
                filterSelection += " \(nestedSelection.display)"
            }
        })
        return "\(sortedBy.isEmpty ? filterSelection : filterSelection + sortedBy)"
    }

    /// Refreshes the results cached for the same path as the current active leaderboard.
    func refresh() {
        if let request = customLeaderboard.flatMap({ LeaderboardRequest(customLeaderboard: $0) }) {
            let clearCacheCondition: (URLRequest) -> Bool = { value in
                request.rawValue.urlRequest?.url?.pathComponents.elementsEqual(value.url?.pathComponents ?? []) == true
            }

            CFCache.default.reset(where: clearCacheCondition)
        }
    }

    /// Formats ranks.
    ///
    /// - Parameter intValue: Rank value.
    /// - Returns: Formatted rank value.
    private func rank(stringValue: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal

        return Int(stringValue).flatMap(numberFormatter.string) ?? stringValue
    }

    /// Name of the athlete at the given index.
    ///
    /// - Parameter index: Index of the athlete.
    /// - Returns: Name of the athlete at the given index.
    private func athleteName(at index: Int) -> String? {
        guard let customLeaderboard = customLeaderboard else {
            return nil
        }

        if let listItem = leaderboardListService.athlete(for: customLeaderboard, atIndex: index) as? LeaderboardListItemTeamSeries,
            let roster = listItem.roster {
            return roster.flatMap({ (athlete) -> String? in
                return athlete.name?.components(separatedBy: " ").dropFirst().first
            }).joined(separator: " & ")
        } else {
            return leaderboardListService.athlete(for: customLeaderboard, atIndex: index)?.user.name
        }
    }

    /// Saves the current custom leaderboard
    func saveCustomLeaderboardForAthlete() {
        if let customLeaderboard = customLeaderboard {
            followAnAthleteService.saveCustomLeaderboardForAthlete(customLeaderboard: customLeaderboard)
        }
    }

    /// Returns the currently saved custom leaderboard
    var followAnAthleteCustomLeaderboard: CustomLeaderboard? {
        return followAnAthleteService.getSavedCustomLeaderboard()
    }

    /// Returns the currently saved custom leaderboard
    var followingAthleteViewModel: LeaderboardAthleteResultCellViewModel? {
        return followAnAthleteService.getFollowingAthleteViewModel()
    }

    /// Image URL for the profile pic of the user at the given index.
    ///
    /// - Parameters
    ///   - index: Index of the user.
    ///   - athlete: Index of the athlete (multiple athletes if teams).
    /// - Returns: URL of the user's profile picture.
    private func athleteImageUrl(at index: Int, athlete: Int = 0) -> URL? {
        guard let customLeaderboard = customLeaderboard else {
            return nil
        }

        if let listItem = leaderboardListService.athlete(for: customLeaderboard, atIndex: index) as? LeaderboardListItemTeamSeries,
            let roster = listItem.roster {
            let pics = roster.flatMap({ (athlete) -> URL? in
                return athlete.profilePic
            })
            guard athlete < pics.count else {
                return nil
            }
            return pics[athlete]
        } else {
            guard athlete == 0 else {
                return nil
            }
            return leaderboardListService.athlete(for: customLeaderboard, atIndex: index)?.user.profilePic
        }
    }

    /// Retrieves the current following athlete including the athlete information
    ///
    /// - Parameters:
    ///   - athleteId: Athlete Id
    ///   - completion: Completion block which includes a DashboardFollowAnAthleteViewModel and an error if occurs
    func getFollowingAthlete(by athleteId: String, completion: @escaping (DashboardFollowAnAthleteViewModel?, Error?) -> Void) {
        followAnAthleteService.getFollowingAthleteDashboardViewModel(by: athleteId, completion: completion)
    }

    /// Follows the athlete
    ///
    /// - Parameter viewModel: LeaderboardAthleteResultCellViewModel
    func followAnAthlete(with viewModel: LeaderboardAthleteResultCellViewModel) {
        followAnAthleteService.followAthlete(with: viewModel)
    }

    /// Unfollows the athlete
    func unFollowAthlete() {
        followAnAthleteService.unFollowAthlete()
    }

}
