//
//  LeaderboardFilterViewModel.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/22/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation
import Simcoe

private struct FilterSelectionOption: FilterViewModelSelectionOption {

    let title: String

    let filterName: String

    var parent: FilterViewModelNestedOption?

    let isSelected: () -> Bool

    let selection: () -> Void

    func didSelect() {
        selection()

        if let filterName = FilterName(rawValue: filterName) {
            switch filterName {
            case .competition:
                Simcoe.track(event: .leaderboardCompetitionFilter,
                             withAdditionalProperties: [.competition: title],
                             on: .leaderboard)
            case .division:
                Simcoe.track(event: .leaderboardDivisionFilter,
                             withAdditionalProperties: [.division: title],
                             on: .leaderboard)
            case .fittestIn, .region, .country, .state:
                Simcoe.track(event: .leaderboardFittestInFilter,
                             withAdditionalProperties: [.fittestIn: ((parent?.title).flatMap { $0.appending(", ") } ?? "").appending(title)],
                             on: .leaderboard)
            case .sort:
                Simcoe.track(event: .leaderboardSortFilter,
                             withAdditionalProperties: [.sort: title],
                             on: .leaderboard)
            case .year:
                Simcoe.track(event: .leaderboardYearFilter,
                             withAdditionalProperties: [.year: title],
                             on: .leaderboard)
            case .occupation:
                Simcoe.track(event: .leaderboardOccupationFilter,
                             withAdditionalProperties: [.occupation: title],
                             on: .leaderboard)
            case .workoutType:
                Simcoe.track(event: .leaderboardWorkoutTypeFilter,
                             withAdditionalProperties: [.workoutType: title],
                             on: .leaderboard)
            case .page, .fittestInDetail, .regionSearch:
                break
            }
        }
    }

}

private struct NestedFilterSelectionOption: FilterViewModelNestedOption {

    let title: String

    let filterName: String

    let selectedOption: () -> String?

    var nestedOptions: [FilterViewModelSelectionOption]

    var parent: FilterViewModelNestedOption?

    let shouldGroupContentAlphabetically: Bool

    init(title: String,
         filterName: String,
         selectedOption: @escaping () -> String?,
         nestedOptions: [FilterViewModelSelectionOption],
         shouldGroupContentAlphabetically: Bool) {
        self.title = title
        self.filterName = filterName
        self.selectedOption = selectedOption
        self.nestedOptions = []
        self.shouldGroupContentAlphabetically = shouldGroupContentAlphabetically

        nestedOptions.forEach { (option) in
            var newOption = option
            newOption.parent = self
            self.nestedOptions.append(newOption)
        }
    }

    func didSelect() {
        return
    }

}

/// View model for a leaderboard filter screen.
final class LeaderboardFilterContent {

    let shouldGroupContentAlphabetically: Bool = false

    var hasSortOptions: Bool {
        return (leaderboardFilterSelectionService?.selectedControls.controls.first(where: { (filter) -> Bool in
            filter.configName == FilterName.sort.rawValue
        })?.data.count ?? 0) > 1
    }

    private(set) var selectionOptions: [FilterViewModelSelectionOption]

    private let leaderboardFilterService: LeaderboardFilterService

    private let leaderboardFilterPersistenceService: LeaderboardFilterPersistenceService

    private var leaderboardFilterSelectionService: LeaderboardFilterSelectionService? {
        didSet {
            selectionOptions = buildSelectionOptions()
            leaderboardFilterSelectionService?.add(subscriber: self)
        }
    }

    /// Delegate that gets notified whenever filters are being adjusted on `self`.
    /// An example for this is the result view controller which upon receiving new filters can update
    /// its displayed results.
    weak var delegate: LeaderboardFilterResponder?

    /// Creates a new `LeaderboardFilterContent` instance with the given services.
    ///
    /// - Parameters:
    ///   - leaderboardFilterService: Filter service for downloading filters.
    ///   - leaderboardFilterPersistenceService: Persistence service for storing leaderboard filters.
    ///   - leaderboardFilterSelectionService: Service for maintaining a selection of filters.
    init(leaderboardFilterService: LeaderboardFilterService,
         leaderboardFilterPersistenceService: LeaderboardFilterPersistenceService,
         leaderboardFilterSelectionService: LeaderboardFilterSelectionService?) {
        selectionOptions = []
        self.leaderboardFilterService = leaderboardFilterService
        self.leaderboardFilterPersistenceService = leaderboardFilterPersistenceService
        self.leaderboardFilterSelectionService = leaderboardFilterSelectionService

        selectionOptions = buildSelectionOptions()
        leaderboardFilterSelectionService?.add(subscriber: self)
    }

    /// Initializer for a filter view model whose filters have yet to be loaded from the API.
    convenience init() {
        self.init(leaderboardFilterService: ServiceFactory.shared.createLeaderboardFilterService(),
                  leaderboardFilterPersistenceService: ServiceFactory.shared.createLeaderboardFilterPersistenceService(),
                  leaderboardFilterSelectionService: nil)
    }

    /// Creates a leaderboard filter view model with an existing leaderboard.
    ///
    /// - Parameter leaderboard: Existing leaderboard whose selections will be used.
    convenience init(leaderboard: CustomLeaderboard) {
        self.init(leaderboardFilterService: ServiceFactory.shared.createLeaderboardFilterService(),
                  leaderboardFilterPersistenceService: ServiceFactory.shared.createLeaderboardFilterPersistenceService(),
                  leaderboardFilterSelectionService: ServiceFactory.shared
                    .createLeaderboardFilterSelectionService(with: leaderboard.controls,
                                                             selectedControls: leaderboard.selectedControls,
                                                             preselection: leaderboard.filterSelection,
                                                             affiliateId: leaderboard.affiliate))
    }

    /// Loads leaderboard filters if they weren't loaded yet.
    ///
    /// - Parameter completion: Completion block that is called upon response.
    func loadFiltersIfNeeded(completion: @escaping (Error?) -> Void) {
        if leaderboardFilterSelectionService == nil {
            leaderboardFilterService.getLeaderboardFilters(completion: { [weak self] (controls, error) in
                if let controls = controls {
                    let selectionService = ServiceFactory.shared.createLeaderboardFilterSelectionService(with: controls, affiliateId: nil)
                    self?.leaderboardFilterSelectionService = selectionService
                    let leaderboardResultViewModel = LeaderboardResultViewModel(customLeaderboard: selectionService?.customLeaderboard)
                    self?.delegate?.viewShouldReload(with: leaderboardResultViewModel,
                                                     scrollingToAthlete: nil,
                                                     onPage: nil,
                                                     showingLoadingView: true)
                    completion(nil)
                } else {
                    completion(error)
                }
            })
        }
    }

}

// MARK: - FilterViewModel
extension LeaderboardFilterContent: FilterViewModel {

    var title: String {
        return GeneralLocalization().filters
    }

    func reset() {
        leaderboardFilterSelectionService?.reset()
        selectionOptions = buildSelectionOptions()
    }

    private func buildSelectionOptions() -> [FilterViewModelSelectionOption] {
        guard let leaderboardFilterSelectionService = leaderboardFilterSelectionService else {
            return []
        }

        var options = [
            createCompetitionFilter(using: leaderboardFilterSelectionService),
            createYearFilter(using: leaderboardFilterSelectionService)
        ]
        options.append(contentsOf: createDynamicFilters(using: leaderboardFilterSelectionService))

        options.sort { (lhs, rhs) -> Bool in
            let sortOrder = leaderboardFilterSelectionService.selectedControls.config?.controls

            guard let lhsIndex = sortOrder?.index(of: lhs.filterName),
                let rhsIndex = sortOrder?.index(of: rhs.filterName) else {
                    return false
            }

            return lhsIndex < rhsIndex
        }

        return options
    }

    private func createCompetitionFilter(using leaderboardFilterSelectionService: LeaderboardFilterSelectionService)
        -> FilterViewModelSelectionOption {
            // Combining competition names for UI with matching API values.
            let nestedOptions = zip(leaderboardFilterSelectionService.competitionNames,
                                    leaderboardFilterSelectionService.availableCompetitions).enumerated()
                // Map the competitions to selection options that let a user pick a competition.
                .map({ competition -> FilterViewModelSelectionOption in
                    // Create selection option with the UI name as title and selection block which updates the selection service's
                    // competition.
                    return FilterSelectionOption(title: competition.element.0,
                                                 filterName: FilterName.competition.rawValue,
                                                 parent: nil,
                                                 isSelected: { leaderboardFilterSelectionService.competition == competition.element.1 },
                                                 selection: { [weak leaderboardFilterSelectionService, weak self] in
                                                    leaderboardFilterSelectionService?.competition = competition.element.1
                                                    self?.selectionOptions = self?.buildSelectionOptions() ?? []
                    })
                })
            return NestedFilterSelectionOption(title: "Competition",
                                               filterName: FilterName.competition.rawValue,
                                               selectedOption: { leaderboardFilterSelectionService.selectedControls.name },
                                               nestedOptions: nestedOptions,
                                               shouldGroupContentAlphabetically: false)
    }

    private func createYearFilter(using leaderboardFilterSelectionService: LeaderboardFilterSelectionService)
        -> FilterViewModelSelectionOption {
            // Combining competition names for UI with matching API values.
            let nestedOptions = leaderboardFilterSelectionService.availableYears(for: leaderboardFilterSelectionService.selectedControls.type)
                .enumerated()
                // Map the competitions to selection options that let a user pick a competition.
                .map({ competition -> FilterViewModelSelectionOption in
                    // Create selection option with the year as title and selection block which updates the selection service's
                    // competition.
                    return FilterSelectionOption(title: competition.element,
                                                 filterName: FilterName.year.rawValue,
                                                 parent: nil,
                                                 isSelected: { leaderboardFilterSelectionService.year == competition.element },
                                                 selection: { [weak leaderboardFilterSelectionService, weak self] in
                                                    leaderboardFilterSelectionService?.year = competition.element
                                                    self?.selectionOptions = self?.buildSelectionOptions() ?? []
                    })
                })
            return NestedFilterSelectionOption(title: "Year",
                                               filterName: FilterName.year.rawValue,
                                               selectedOption: { leaderboardFilterSelectionService.selectedControls.year },
                                               nestedOptions: nestedOptions,
                                               shouldGroupContentAlphabetically: false)
    }

    private func createDynamicFilters(using leaderboardFilterSelectionService: LeaderboardFilterSelectionService)
        -> [FilterViewModelSelectionOption] {
            // Get indices of the top filters
            let topFilterIndices = 0..<leaderboardFilterSelectionService.numberOfAvailableFilters
            return topFilterIndices.flatMap { (filterIndex) in
                createDynamicFilter(with: leaderboardFilterSelectionService, at: filterIndex)
            }
    }

    /// Creates a dynamic filter at the given index. For the main filter UI, this is the first page a user sees.
    /// The returned selection option could be one of `fittest in`, `division`, `sort` or other.
    ///
    /// - Parameters:
    ///   - leaderboardFilterSelectionService: Service used for filter selection.
    ///   - index: Index of the filter whose selection structure has to be created.
    /// - Returns: Selection option or nil, if the given filter has only one or no elements.
    private func createDynamicFilter(with leaderboardFilterSelectionService: LeaderboardFilterSelectionService,
                                     at index: Int) -> FilterViewModelSelectionOption? {
        // Get the number of options for the particular top level filter.
        let numberOfOptions = leaderboardFilterSelectionService.numberOfOptions(forFilterAt: [index])

        // There should be more than one option, otherwise it doesn't make sense to show a menu for this.
        guard numberOfOptions > 1 else {
            return nil
        }

        // Get all the option indices, these will be the index within the filter at `index`
        let filterOptionIndices = 0..<numberOfOptions

        // Create selection options - these themselves can be nested or single select, which
        // will be determined in `buildNestedComponent`.
        let selectionOptions = filterOptionIndices.map { subIndex -> FilterViewModelSelectionOption in
            return buildNestedComponent(using: leaderboardFilterSelectionService,
                                        existingIndexPath: [index, subIndex])
        }

        // Return a nested menu with all the created selection options.
        return NestedFilterSelectionOption(title: leaderboardFilterSelectionService.nameOfFilter(at: index),
                                           filterName: leaderboardFilterSelectionService.filter(at: index).configName,
                                           selectedOption: {
                                            // Find any selected index path that begins with the same top filter index.
                                            leaderboardFilterSelectionService.selectedIndexPaths.first(where: { (indexPath) -> Bool in
                                                indexPath.first == index
                                            // Find the name that matches this selected index path for showing as `selected option`
                                            }).flatMap {
                                                leaderboardFilterSelectionService.displayNameForFilter(at: $0)
                                            }},
                                           nestedOptions: selectionOptions,
                                           shouldGroupContentAlphabetically: false)
    }

    /// Builds a nested or single component (depending on content) at the given index path. The passed in index path could be
    /// [0, 1, 3], which might point to ["fittest in", "US States", "CA"] - for index path [0, 1], this would return a nested
    /// selection option that contains all the US states. For index path [0, 1, 3] this would return a single selection option
    /// which contains only "CA".
    ///
    /// - Parameters:
    ///   - leaderboardFilterSelectionService: Service in use for filter selection.
    ///   - existingIndexPath: Index path used for determining and returning type of option.
    /// - Returns: Selection option, as described above.
    private func buildNestedComponent(using leaderboardFilterSelectionService: LeaderboardFilterSelectionService,
                                      existingIndexPath: IndexPath) -> FilterViewModelSelectionOption {
        // Get the number of options at the index path so far.
        let numberOfOptions = leaderboardFilterSelectionService.numberOfOptions(forFilterAt: existingIndexPath)

        // If there are no further options, then this existing index path points to a single selection item which can be returned.
        if numberOfOptions == 0 {
            return FilterSelectionOption(title: leaderboardFilterSelectionService.displayNameForFilter(at: existingIndexPath),
                                         filterName: leaderboardFilterSelectionService.filter(at: existingIndexPath.first ?? 0).configName,
                                         parent: nil,
                                         isSelected: { leaderboardFilterSelectionService.selectedIndexPaths.contains(existingIndexPath) },
                                         selection: { [weak leaderboardFilterSelectionService] in
                                            leaderboardFilterSelectionService?.selectFilter(at: existingIndexPath)
            })
        // Otherwise there will be more nesting.
        } else {
            // Create an array of the nested index paths within the filter at the existing index path.
            let nestedIndexPaths = (0..<numberOfOptions).map({ (optionIndex) -> IndexPath in
                return existingIndexPath.appending(optionIndex)
            })

            let nestedOptions = nestedIndexPaths.map { buildNestedComponent(using: leaderboardFilterSelectionService,
                                                                            existingIndexPath: $0) }

            let isFittestFilter = leaderboardFilterSelectionService.filter(at: existingIndexPath.first ?? 0)
                .configName == FilterName.fittestIn.rawValue

            let shouldGroupAlphabetically = existingIndexPath.count > 1 && isFittestFilter && nestedOptions.count >= 50

            // Return a nested selection option, recursively calling this function to create the nested components.
            return NestedFilterSelectionOption(title: leaderboardFilterSelectionService.displayNameForFilter(at: existingIndexPath),
                                               filterName: leaderboardFilterSelectionService.filter(at: existingIndexPath.first ?? 0).configName,
                                               selectedOption: {
                                                /// Find a selected option index path and its matching name (if available) for display
                                                /// as selected option.
                                                leaderboardFilterSelectionService.selectedIndexPaths.first(where: { (indexPath) -> Bool in
                                                    guard indexPath.count - existingIndexPath.count >= 0 else {
                                                        return false
                                                    }
                                                    return indexPath.dropLast(indexPath.count - existingIndexPath.count)
                                                        .elementsEqual(existingIndexPath)
                                                }).flatMap {
                                                    leaderboardFilterSelectionService.displayNameForFilter(at: $0)
                                                }},
                                               nestedOptions: shouldGroupAlphabetically ? nestedOptions.sorted(by: { option1, option2 in
                                                return option1.title.uppercased() < option2.title.uppercased()
                                               }) : nestedOptions,
                                               shouldGroupContentAlphabetically: shouldGroupAlphabetically)
        }
    }

}

// MARK: - LeaderboardFilterSubscriber
extension LeaderboardFilterContent: LeaderboardFilterSubscriber {

    func filtersChanged(on selectionService: LeaderboardFilterSelectionService) {
        let viewModel = LeaderboardResultViewModel(customLeaderboard: selectionService.customLeaderboard)
        delegate?.viewShouldReload(with: viewModel, scrollingToAthlete: nil, onPage: nil, showingLoadingView: true)
    }

}
