//
//  WorkoutStatsViewModel.swift
//  CrossFit Games
//
//  Created by Malinka S on 11/17/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// View model to display the workout statistics
struct WorkoutStatsViewModel {

    // MARK: - Public Properties
    
    /// Workout name
    let workoutDisplayName: String

    /// Rank of the current athlete
    let rank: String

    /// Percentile value
    let percentileValue: Int?

    /// Workout score
    let workoutScore: String

    /// Workout type id
    let workoutTypeId: String

    /// Percentile value which includes the suffix (st, th, nd rd)
    var percentileTextValue: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        return percentileValue.flatMap { numberFormatter.string(from: NSNumber(value: $0)) }
    }

}
