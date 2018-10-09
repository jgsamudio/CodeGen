//
//  BasicWorkoutScore.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

struct BasicWorkoutScore: WorkoutScore, Decodable {

    private enum CodingKeys: String, CodingKey {
        case breakdown
        case judge
        case scoreDisplay = "scoredisplay"
        case time
        case workoutRank = "workoutrank"
        case scoreDetails = "scoredetails"
    }

    let breakdown: String?

    let judge: String?

    let scoreDisplay: String

    let time: TimeInterval?

    let workoutRank: String

    var ordinalID: String = "0"

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let nestedContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .scoreDetails) {
            breakdown = try nestedContainer.decodeIfPresent(String.self, forKey: .breakdown)
            judge = try nestedContainer.decodeIfPresent(String.self, forKey: .judge)
        } else {
            breakdown = nil
            judge = nil
        }

        scoreDisplay = try container.decode(String.self, forKey: .scoreDisplay)
        time = try container.decodeIfPresent(Int.self, forKey: .time).flatMap({ (intValue) -> TimeInterval? in
            TimeInterval(intValue)
        })
        workoutRank = try container.decode(String.self, forKey: .workoutRank)
    }

}
