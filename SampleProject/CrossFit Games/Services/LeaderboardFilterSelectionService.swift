//
//  LeaderboardFilterSelectionService.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/20/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Service for selecting leaderboard filters.
final class LeaderboardFilterSelectionService {

    /// List of subscribers.
    var subscribers: [LeaderboardFilterSubscriber] {
        return _subscribers.allObjects.flatMap { $0 as? LeaderboardFilterSubscriber }
    }

    private let _subscribers = NSHashTable<AnyObject>()

    private let competitionInfoService: CompetitionInfoService

    /// All leaderboard controls (competition and year selections).
    private(set) var controls: [LeaderboardControls]

    /// Currently selected controls (for competition and year).
    private(set) var selectedControls: LeaderboardControls

    /// Currently selected selection (of filters).
    private(set) var selection: [LeaderboardFilterSelection] = []

    /// Affiliate ID to set.
    private(set) var affiliateId: String?

    /// Custom leaderboard with the selection set on `self`.
    var customLeaderboard: CustomLeaderboard {
        get {
            return CustomLeaderboard(controls: controls,
                                     filterSelection: selection,
                                     selectedControls: selectedControls,
                                     affiliate: affiliateId)
        }
        set {
            self.controls = newValue.controls
            self.selection = defaultSelection(forYear: newValue.selectedControls.year,
                                              competition: newValue.selectedControls.type)
            self.selectedControls = newValue.selectedControls
            self.affiliateId = newValue.affiliate

            preselect(preselection: newValue.filterSelection)
            selectionChanged()
        }
    }

    /// Currently selected index paths on the contained filters.
    var selectedIndexPaths: [IndexPath] {
        /// Getting all index paths for a filter selection.
        ///
        /// - Parameters:
        ///   - filterIndex: Index of the filter (added to the index path as first index).
        ///   - filterSelection: Filter selection whose index path is to be returned.
        /// - Returns: Index path for the filter's selection.
        func indexPathForFilterSelection(filterIndex: Int, filterSelection: LeaderboardFilterSelection) -> IndexPath? {
            switch filterSelection {
            case .defaultSelection(filter: let filter, selection: let data):
                return filter.data.index(where: { data.value == $0.value })
                    .flatMap({ dataIndex -> IndexPath? in
                        return IndexPath(indexes: [filterIndex, dataIndex])
                    })
            case .regionSelect(filter: let filter, selection: let selection, region: let region, nestedRegion: let nestedRegion):
                var indexPath = IndexPath(index: filterIndex)
                if let regionOrCountrySelectionIndex = filter.data.index(where: { (data) -> Bool in
                    data.value == selection.value
                }) {
                    indexPath.append(regionOrCountrySelectionIndex)
                }
                if let regionSelectionIndex = selection.regions.index(where: { (data) -> Bool in
                    data.value == region.value
                }) {
                    indexPath.append(regionSelectionIndex)
                }
                if let nestedRegionSelectionIndex = (region as? RegionFilterData)?.states?.index(where: { (data) -> Bool in
                    data.value == nestedRegion?.value
                }) {
                    indexPath.append(nestedRegionSelectionIndex)
                }
                return indexPath
            case .multiSelect(filter: let filter, selection: let data, nestedSelection: let nested):
                return filter.data.index(where: { data.value == $0.value }).flatMap({ dataIndex -> IndexPath? in
                    guard let nestedSelectionIndex = data.selects.index(where: { (nestedSelection) -> Bool in
                        nested.value == nestedSelection.value
                    }) else {
                        return nil
                    }

                    return IndexPath(indexes: [filterIndex, dataIndex, nestedSelectionIndex])
                })
            }
        }

        // Indices of all available filters.
        let availableFilterIndices = Array(0..<numberOfAvailableFilters)

        // Map each filter to it's selection.
        return availableFilterIndices.flatMap({ filterIndex in
            return selection.first(where: { (selection) -> Bool in
                return selection.filter.configName == relevantFilters[filterIndex].configName
            })
                // Get the index path with the filter's index and the selection for that filter.
                .map { (filterIndex, $0) }
                .flatMap(indexPathForFilterSelection)
        })
    }

    /// Year of the selection.
    var year: String {
        get {
            return selectedControls.year
        }
        set {
            if let newSelection = controls.first(where: { (controls) -> Bool in
                controls.year == newValue && controls.type == selectedControls.type
            }) {
                selectedControls = newSelection
                selection = defaultSelection(forYear: newSelection.year, competition: newSelection.type)
                selectionChanged()
            }
        }
    }

    /// Competition of the selection.
    var competition: String {
        get {
            return selectedControls.type
        }
        set {
            if let newSelection = controls.first(where: { (controls) -> Bool in
                controls.type == newValue && controls.year == selectedControls.year
            }) ?? controls.first(where: { (controls) -> Bool in
                controls.type == newValue
            }) {
                selectedControls = newSelection
                selection = defaultSelection(forYear: newSelection.year, competition: newSelection.type)
                selectionChanged()
            }
        }
    }

    /// Names to display in the UI for the available competitions.
    var competitionNames: [String] {
        return uniqueControls.map({ (controls) -> String in
            return controls.name
        })
    }

    /// Available competitions to set on `self.competition`.
    var availableCompetitions: [String] {
        return uniqueControls.map { (controls) -> String in
            return controls.type
        }
    }

    /// Number of the available filters.
    var numberOfAvailableFilters: Int {
        return relevantFilters.count
    }

    /// Adds the given subscriber to the list of filter selection observers.
    ///
    /// - Parameter subscriber: New subscriber.
    func add(subscriber: LeaderboardFilterSubscriber) {
        _subscribers.add(subscriber)
    }

    /// Removes the given subscriber from the list of filter selection observers.
    ///
    /// - Parameter subscriber: Subscriber.
    func remove(subscriber: LeaderboardFilterSubscriber) {
        _subscribers.remove(subscriber)
    }

    private var uniqueControls: [LeaderboardControls] {
        return Array(controls.reduce([LeaderboardControls](), { (result, item) -> [LeaderboardControls] in
            if result.contains(where: { $0.type == item.type }) {
                return result
            } else {
                var _result = result
                _result.append(item)
                return _result
            }
        }))
    }

    private var relevantFilters: [LeaderboardFilter] {
        return selectedControls.controls.filter { !$0.isYearFilter && !$0.isCompetitionFilter }
    }

    init?(controls: [LeaderboardControls],
          selectedControls: LeaderboardControls? = nil,
          preselection: [LeaderboardFilterSelection] = [],
          competitionInfoSerivce: CompetitionInfoService,
          affiliateId: String? = nil) {
        guard let firstControls = selectedControls
            ?? LeaderboardFilterSelectionService
                .firstStartedCompetition(outOf: controls,
                                         competitionInfoService: competitionInfoSerivce) else {
                                            return nil
        }

        // Default initialization
        self.controls = controls
        self.selectedControls = firstControls
        self.affiliateId = affiliateId
        self.competitionInfoService = competitionInfoSerivce
        selection = defaultSelection(forYear: firstControls.year, competition: firstControls.type)

        // If there are year/competition filters, apply those and reload selection to the default selection
        if let yearSelection = preselection.first(where: { (selection) -> Bool in
            selection.filter.isYearFilter
        }), let competitionSelection = preselection.first(where: { (selection) -> Bool in
            selection.filter.isCompetitionFilter
        }) {
            self.selectedControls = controls.first(where: { (controls) -> Bool in
                controls.year == yearSelection.selection.value
                    && controls.type == competitionSelection.selection.value
            }) ?? firstControls
            selection = defaultSelection(forYear: firstControls.year, competition: firstControls.type)
        }

        preselect(preselection: preselection)
    }

    private func selectionChanged() {
        subscribers.forEach { (subscriber) in
            subscriber.filtersChanged(on: self)
        }
    }

    private func preselect(preselection: [LeaderboardFilterSelection]) {
        // Apply all preselections as needed after removing those filters from the selection first.
        selection = selection.filter({ (selection) -> Bool in
            !preselection.contains(where: { (otherSelection) -> Bool in
                selection.filter.configName == otherSelection.filter.configName
            })
        })
        selection.append(contentsOf: preselection)
    }

    /// Available years for a given competition.
    ///
    /// - Parameter competition: Competition whose available years should be returned.
    /// - Returns: Array of all years that are available for the given competition.
    func availableYears(for competition: String) -> [String] {
        return Array(Set(controls.filter { $0.type == competition }.map { $0.year })).sorted().reversed()
    }

    /// Number of options for a filter at a specific index path.
    ///
    /// - Parameter indexPath: Index path describing the filter.
    /// - Returns: Number of options selectable for this filter.
    func numberOfOptions(forFilterAt indexPath: IndexPath) -> Int {
        guard let firstIndex = indexPath.first, relevantFilters[firstIndex].data.count > 0 else {
            return 0
        }

        guard let secondIndex = indexPath.dropFirst().first else {
            return relevantFilters[firstIndex].data.count
        }

        switch relevantFilters[firstIndex].data[secondIndex] {
        case let val as MultiselectLeaderboardFilterData:
            if indexPath.dropFirst().count == 1 {
                return val.selects.count
            } else {
                return 0
            }
        case let val as RegionSelectionFilterData:
            if indexPath.count == 3 {
                return (val.regions[indexPath[2]] as? RegionFilterData)?.states?.count ?? 0
            } else if indexPath.count == 2 {
                return val.regions.count
            } else {
                return 0
            }
        default:
            return 0
        }
    }

    /// UI name of the filter at the given index.
    ///
    /// - Parameter index: Index of the filter.
    /// - Returns: Name of the specified filter.
    func nameOfFilter(at index: Int) -> String {
        return relevantFilters[index].label ?? ""
    }

    /// Gets the display name for a filter at the given index path.
    ///
    /// - Parameter indexPath: Index path describing the path to the filter.
    /// - Returns: Display name of the filter.
    func displayNameForFilter(at indexPath: IndexPath) -> String {
        guard let firstIndex = indexPath.first,
            let secondIndex = indexPath.dropFirst().first else {
                return ""
        }

        switch relevantFilters[firstIndex].data[secondIndex] {
        case let val as MultiselectLeaderboardFilterData:
            if let nextIndex = indexPath.dropFirst(2).first {
                return val.selects[nextIndex].display
            } else {
                return val.display
            }
        case let val as RegionSelectionFilterData:
            if let regionIndex = indexPath.dropFirst(2).first {
                if let stateIndex = indexPath.dropFirst(3).first {
                    return (val.regions[regionIndex] as? RegionFilterData)?.states?[stateIndex].display ?? ""
                } else {
                    return val.regions[regionIndex].display
                }
            } else {
                return val.display
            }
        default:
            return relevantFilters[firstIndex].data[secondIndex].display
        }
    }

    /// Selects a filter at the given index path.
    ///
    /// - Parameter indexPath: Index path describing selected components.
    func selectFilter(at indexPath: IndexPath) {
        guard let firstIndex = indexPath.first,
            let secondIndex = indexPath.dropFirst().first else {
                return
        }

        selection = selection.filter({ (duplicate) -> Bool in
            return duplicate.filter.configName != relevantFilters[firstIndex].configName
        })

        switch relevantFilters[firstIndex].data[secondIndex] {
        case let val as MultiselectLeaderboardFilterData:
            selection.append(.multiSelect(filter: relevantFilters[firstIndex],
                                          selection: val,
                                          nestedSelection: val.selects[indexPath.dropFirst(2).first ?? 0]))
        case let val as SortableLeaderboardFilterData:
            selection.append(.defaultSelection(filter: relevantFilters[firstIndex],
                                               selection: relevantFilters[firstIndex].data[secondIndex]))
            val.controls.forEach({ (childFilter) in
                selection = selection.filter({ (duplicate) -> Bool in
                    return duplicate.filter.configName != childFilter.configName
                })

                guard let firstValue = childFilter.data.first else {
                    return
                }

                selection.append(LeaderboardFilterSelection.defaultSelection(filter: childFilter, selection: firstValue))
            })
        case let val as RegionSelectionFilterData:
            guard let thirdIndex = indexPath.dropFirst(2).first else {
                return
            }
            let fourthIndex = indexPath.dropFirst(3).first
            selection.append(.regionSelect(filter: relevantFilters[firstIndex],
                                           selection: val,
                                           region: val.regions[thirdIndex],
                                           nestedRegion: fourthIndex.flatMap { (val.regions[thirdIndex] as? RegionFilterData)?.states?[$0] }))
        default:
            selection.append(.defaultSelection(filter: relevantFilters[firstIndex],
                                               selection: relevantFilters[firstIndex].data[secondIndex]))
        }
        selectionChanged()
    }

    /// Returns a filter at the given index.
    ///
    /// - Parameter index: Index of the filter.
    /// - Returns: Filter at the given index.
    func filter(at index: Int) -> LeaderboardFilter {
        return relevantFilters[index]
    }

    /// Resets filters for the current year and competition.
    func reset() {
        let mostRecentOpen = LeaderboardFilterSelectionService
            .firstStartedCompetition(outOf: controls,
                                     competitionInfoService: competitionInfoService)
        competition = mostRecentOpen?.type ?? competition
        year = mostRecentOpen?.year ?? year
        selection = defaultSelection(forYear: year,
                                     competition: competition)
        selectionChanged()
    }

    private static func firstStartedCompetition(outOf controls: [LeaderboardControls],
                                                competitionInfoService: CompetitionInfoService) -> LeaderboardControls? {
        return controls.sorted(by: { $0.year.compare($1.year) == .orderedDescending }).first(where: { (controls) -> Bool in
            guard let startDate = competitionInfoService.startDate(for: controls.type, in: controls.year) else {
                return true
            }
            return startDate.timeIntervalSince(DatePicker.shared.date) <= 0
        })
    }

    private func defaultSelection(forYear year: String, competition: String) -> [LeaderboardFilterSelection] {
        guard let obj = controls.first(where: { (controls) -> Bool in
            controls.year == year && controls.type == competition
        }) else {
            return []
        }

        var selection: [LeaderboardFilterSelection] = []
        if let yearFilter = obj.controls.first(where: { (filter) -> Bool in
            filter.isYearFilter
        }), let yearMatch = yearFilter.data.first(where: { (data) -> Bool in
            data.value == year
        }) {
            selection.append(.defaultSelection(filter: yearFilter, selection: yearMatch))
        }

        if let competitionFilter = obj.controls.first(where: { (filter) -> Bool in
            filter.isCompetitionFilter
        }), let competitionMatch = competitionFilter.data.first(where: { (data) -> Bool in
            data.value == competition
        }) {
            selection.append(.defaultSelection(filter: competitionFilter, selection: competitionMatch))
        }

        relevantFilters.forEach { (filter) in
            guard let firstFilter = filter.data.first else {
                return
            }

            switch firstFilter {
            case let val as MultiselectLeaderboardFilterData:
                guard let firstSelect = val.selects.first else {
                    return
                }
                selection.append(LeaderboardFilterSelection.multiSelect(filter: filter,
                                                                        selection: val,
                                                                        nestedSelection: firstSelect))
            case let val as RegionSelectionFilterData:
                guard let regionSelect = val.regions.first else {
                    return
                }
                selection.append(LeaderboardFilterSelection.regionSelect(filter: filter,
                                                                         selection: val,
                                                                         region: regionSelect,
                                                                         nestedRegion: nil))
            default:
                selection.append(LeaderboardFilterSelection.defaultSelection(filter: filter, selection: firstFilter))
            }
        }

        return selection
    }

}
