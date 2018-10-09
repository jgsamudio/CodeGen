//
//  LeaderboardResultLayout.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/10/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Layout of a leaderboard result screen.
///
/// - `default`: Default layout with view below navigation bar to show filters.
/// - minimalLeaderboard: Minimal leaderboard with a fixed, 40pt height navigation bar, custom title and no navigation bar buttons (except
///   a filter button when viewing an affiliate leaderboard).
enum LeaderboardResultLayout {
    case `default`
    case minimalLeaderboard(title: String, subtitle: String?, isAffiliateLeaderboard: Bool)
}
