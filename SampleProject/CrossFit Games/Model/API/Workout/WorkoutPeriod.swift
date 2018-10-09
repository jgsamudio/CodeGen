//
//  WorkoutPeriod.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/24/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Represents the valid period which a workout is going to exist
struct WorkoutPeriod: Decodable {

    /// Workout start time
    let startDate: Date

    /// Workout end time
    let endDate: Date

    private enum CodingKeys: String, CodingKey {
        case startTime = "value"
        case endTime = "value2"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let startTimeInterval = try values.decode(TimeInterval.self, forKey: .startTime)
        let endTimeInterval = try values.decode(TimeInterval.self, forKey: .endTime)
        startDate = Date(timeIntervalSince1970: TimeInterval(startTimeInterval))
        endDate = Date(timeIntervalSince1970: TimeInterval(endTimeInterval))
    }
}
