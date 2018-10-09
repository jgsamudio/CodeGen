//
//  WorkoutScore.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Workout score in a leaderboard list item.
protocol WorkoutScore {

    /// Rank of the user in a workout.
    var workoutRank: String { get }

    /// Display value for the score.
    var scoreDisplay: String { get }

    /// Time it took the user to complete the workout.
    var time: TimeInterval? { get }

    /// Breakdown of the score.
    var breakdown: String? { get }

    /// Judge for the score. Might come as part of the breakdown.
    var judge: String? { get }

    /// ID of the ordinal for this workout score.
    var ordinalID: String { get }
    
}
