//
//  ExtendedWorkoutScore.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

struct ExtendedWorkoutScore: WorkoutScore, Decodable {

    private enum CodingKeys: String, CodingKey {
        case breakdown
        case judge
        case scoreDisplay
        case time
        case workoutRank = "workoutrank"
        case ordinal
    }

    let breakdown: String?

    let judge: String?

    let scoreDisplay: String

    let time: TimeInterval?

    let workoutRank: String

    let ordinalID: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        breakdown = try container.decodeIfPresent(String.self, forKey: .breakdown)
        judge = try container.decodeIfPresent(String.self, forKey: .judge)
        scoreDisplay = try container.decodeIfPresent(String.self, forKey: .scoreDisplay) ?? ""
        time = try container.decodeIfPresent(String.self, forKey: .time).flatMap({ (timeString) -> TimeInterval? in
            TimeIntervalFormatter().number(from: timeString)?.doubleValue
        })
        workoutRank = try container.decode(String.self, forKey: .workoutRank)
        let ordinalID = try (try? container.decode(Int.self, forKey: .ordinal)).flatMap(String.init)
            ?? container.decode(String.self, forKey: .ordinal)
        self.ordinalID = ordinalID
    }

}
