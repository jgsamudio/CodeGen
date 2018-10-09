//
//  LeaderboardListItem.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Leaderboard list item, containing a user and all the scores that have been recorded for that user.
protocol LeaderboardListItem {

    /// User whom this list item belongs to.
    var user: LeaderboardAthlete { get }

    /// The scores listed for this leaderboard list item.
    var scores: [WorkoutScore] { get }

}
