//
//  CustomLeaderboard.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/22/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Custom leaderboard, described by the controls available for the leaderboard as well as the user's filter selection.
struct CustomLeaderboard: Codable, Hashable {

    // MARK: - Public Properties
    
    /// Leaderboard controls available for selection.
    let controls: [LeaderboardControls]

    /// Filter selection the user made.
    var filterSelection: [LeaderboardFilterSelection]

    /// Selected competition type.
    let selectedControls: LeaderboardControls

    /// Affiliate ID to search for.
    var affiliate: String?

    var hashValue: Int {
        // Compute hash value out of all the elements that make a custom leaderboard unique for a request.
        return controls
            .map { $0.identifier }
            .joined()
            .appending(filterSelection.sorted(by: { (lhs, rhs) -> Bool in
                lhs.filter.configName.compare(rhs.filter.configName) == .orderedAscending
            }).map { $0.filter.configName.appending($0.selection.value) }.joined())
            .appending(selectedControls.identifier)
            .appending(affiliate ?? "")
            .hash
    }

    /// Formats filter model into a dictionary for requests to utilize
    var requestBody: [String: String] {
        var body = [String: String]()
        filterSelection.forEach { (filterSelection) in
            guard !filterSelection.filter.isYearFilter && !filterSelection.filter.isCompetitionFilter else {
                return
            }

            switch filterSelection {
            case LeaderboardFilterSelection.regionSelect(filter: _, selection: let selection, region: let region, nestedRegion: let nestedRegion):
                if selection.value == FilterName.region.rawValue {
                    body[FilterName.region.rawValue] = region.value
                } else if selection.value == FilterName.country.rawValue {
                    body[FilterName.region.rawValue] = ""
                    body[FilterName.country.rawValue] = region.value
                    if let nestedRegion = nestedRegion, !nestedRegion.value.isEmpty {
                        body[FilterName.state.rawValue] = nestedRegion.value
                    }
                }
            case LeaderboardFilterSelection.defaultSelection(filter: let filter, selection: let selection):
                body[filter.configName] = selection.value
            case .multiSelect(filter: let filter, selection: let selection, nestedSelection: let nested):
                body[filter.configName] = selection.value
                body[filter.configName.appending("1")] = nested.value
            }
        }
        return body
    }

}

    // MARK: - Public Functions
    
func == (_ lhs: CustomLeaderboard, _ rhs: CustomLeaderboard) -> Bool {
    return lhs.filterSelection.sorted(by: { (lhs, rhs) -> Bool in
        lhs.filter.configName.compare(rhs.filter.configName) == .orderedAscending
    }).elementsEqual(rhs.filterSelection.sorted(by: { (lhs, rhs) -> Bool in
        lhs.filter.configName.compare(rhs.filter.configName) == .orderedAscending
    }))
        && lhs.selectedControls == rhs.selectedControls
}
