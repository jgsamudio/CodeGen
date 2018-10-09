//
//  LeaderboardSearchCondition.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/16/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// A leaderboard search condition indicates parameters that are used to find a particular page
/// on a leaderboard. This can be through an athlete ID (case: athlete) always returning that athlete's page
/// (even if another page parameter is set as well) or by providing a specific page index.
enum LeaderboardSearchCondition {
    case page(pageIndex: Int)
    case athlete(athleteId: String)
}
