//
//  FilterOptionName.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/16/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Filter option display name inferred via leaderboard controls, the filter's ID (e.g. 2 for fittest
/// in: "Individual Women") and the filter name ("fittest_in" for fittest in filter).
struct FilterOptionName: CustomStringConvertible {

    /// ID of the filter option ("2" for individual women for example)
    let id: String

    /// Filter name to read options from ("fittest_in" for fittest filter for example)
    let filterName: FilterName

    /// Leaderboard controls to read filters
    let leaderboardControls: LeaderboardControls

    var description: String {
        return leaderboardControls.controls.first(where: { (filter) -> Bool in
            filter.configName == filterName.rawValue
        })?.data.first(where: { (data) -> Bool in
            data.value == id
        })?.display ?? ""
    }

}
