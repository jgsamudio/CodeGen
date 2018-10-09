//
//  LeaderboardFilterPostProcessing.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/19/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Post processing structure for processing leaderboard controls in a similar manner as CIFilter processes images.
struct LeaderboardFilterPostProcessing {

    /// Leaderboard control input.
    let input: [LeaderboardFilter]

    /// Leaderboard control output.
    var output: [LeaderboardFilter] {
        var filters = input
        filters = removeRegionSearch(filters: filters)
        filters = removeDuplicate(filters: filters)
        if let regionFilterIndex = filters.index(where: { (filter) -> Bool in
            filter.configName == FilterName.region.rawValue
        }) {
            let regionFilter = filters.remove(at: regionFilterIndex)
            filters.insert(restructureRegionFilter(filter: regionFilter), at: regionFilterIndex)
        }

        return filters
    }

    private func removeRegionSearch(filters: [LeaderboardFilter]) -> [LeaderboardFilter] {
        return filters.filter { $0.configName != FilterName.regionSearch.rawValue }
    }

    /// Removes duplicate filters, keeping only the one with the most data in it. (use case: two region filters)
    ///
    /// - Parameter filters: Filters to remove duplicates from.
    /// - Returns: Filtered filters.
    private func removeDuplicate(filters: [LeaderboardFilter]) -> [LeaderboardFilter] {
        var filteredFilters = filters

        let duplicates = filteredFilters.filter { (potentialDuplicate) -> Bool in
            filteredFilters.filter { $0.configName == potentialDuplicate.configName }.count > 1
        }

        let duplicatesSortedByNumberOfElementsDescending = duplicates.sorted { (lhs, rhs) -> Bool in
            lhs.data.count > rhs.data.count
        }

        let removingDuplicatesWithLessElements = duplicatesSortedByNumberOfElementsDescending
            .reduce([LeaderboardFilter]()) { (incrementee, incrementor) -> [LeaderboardFilter] in
                var result = incrementee
                if !incrementee.contains(where: { (filter) -> Bool in
                    filter.configName == incrementor.configName
                }) {
                    result.append(incrementor)
                }
                return result
        }

        // Filter tongue-twister incoming in 3... 2... 1...
        filteredFilters = filteredFilters.filter({ (filter) -> Bool in
            !removingDuplicatesWithLessElements.contains(where: { (otherFilter) -> Bool in
                filter.configName == otherFilter.configName
            })
        })

        filteredFilters.append(contentsOf: removingDuplicatesWithLessElements)

        return filteredFilters
    }

    private func restructureRegionFilter(filter: LeaderboardFilter) -> LeaderboardFilter {
        let regions = extractRegions(filter: filter)
        let countries = extractCountries(filter: filter).map { addAllCountryFilter(to: $0) }
        let customData: [LeaderboardFilterData] = [RegionSelectionFilterData(value: "region", display: "Region", regions: regions),
                                                   RegionSelectionFilterData(value: "country", display: "Country", regions: countries)]

        return LeaderboardFilter(configName: filter.configName,
                                 name: filter.name,
                                 label: filter.label,
                                 type: filter.type,
                                 data: customData)
    }

    /// Extracts region filters from the given filter.
    ///
    /// - Parameter filter: Filter to get regions from.
    /// - Returns: Array with all the CrossFit regions.
    private func extractRegions(filter: LeaderboardFilter) -> [LeaderboardFilterData] {
        return filter.data.flatMap { $0 as? DefaultLeaderboardFilterData }
    }

    /// Gives you all the countries within the given filter. Assuming it's a region filter.
    ///
    /// - Parameter filter: Filter.
    /// - Returns: Region filter data with all the countries.
    private func extractCountries(filter: LeaderboardFilter) -> [RegionFilterData] {
        // And the journey all the way down to the center of the earth begins ...
        return filter.data
            // Finding the search filter in regions.
            .flatMap { $0 as? SortableLeaderboardFilterData }
            .first?
            // Digging into that one's one and only control: region_search.
            .controls
            .first?
            // That's where all the magic happens: country data. Should all be region data. Hopefully.
            .data
            .flatMap { $0 as? RegionFilterData } ?? []
    }

    /// Inserts an "All {Country}" filter in the states list.
    ///
    /// - Parameter filter: Filter to modify.
    /// - Returns: Modified filter.
    private func addAllCountryFilter(to filter: RegionFilterData) -> RegionFilterData {
        if var states = filter.states, !states.isEmpty {
            let allStateFilter = RegionFilterData(display: "All \(filter.display)", value: "", name: "", states: nil)
            states.insert(allStateFilter, at: 0)
            return RegionFilterData(display: filter.display,
                                    value: filter.value,
                                    name: filter.name,
                                    states: states)
        } else {
            return filter
        }
    }

}
