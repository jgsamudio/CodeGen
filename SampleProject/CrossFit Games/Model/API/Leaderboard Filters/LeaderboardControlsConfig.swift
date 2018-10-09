//
//  LeaderboardControlsConfig.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Config for leaderboard controls
struct LeaderboardControlsConfig: Codable {

    /// Registration date range.
    let registration: DateRange?

    /// Array indicating the order of filters.
    let controls: [String]?

}
