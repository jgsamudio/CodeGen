//
//  TeamSeriesWorkoutScore.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

struct TeamSeriesWorkoutScore: WorkoutScore, Decodable {

    private enum CodingKeys: String, CodingKey {
        case breakdown
        case judge
        case scoreDisplay
        case time
        case workoutRank = "rank"
        case ordinal
    }

    // MARK: - Public Properties
    
    let breakdown: String?

    let judge: String?

    let scoreDisplay: String

    let time: TimeInterval?

    let workoutRank: String

    let ordinalID: String

    // MARK: - Initialization
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        do {
            time = try container.decodeIfPresent(Int.self, forKey: .time).flatMap { TimeInterval($0) }
        } catch DecodingError.typeMismatch(_, _) {
            time = try container.decodeIfPresent(String.self, forKey: .time).flatMap { Double($0) }
        }
        do {
            workoutRank = try String(container.decode(Int.self, forKey: .workoutRank))
        } catch DecodingError.typeMismatch(_, _) {
            workoutRank = try container.decode(String.self, forKey: .workoutRank)
        }

        breakdown = try container.decodeIfPresent(String.self, forKey: .breakdown)
        judge = try container.decodeIfPresent(String.self, forKey: .judge)
        scoreDisplay = try container.decode(String.self, forKey: .scoreDisplay)
        let ordinalID = try (try? container.decode(Int.self, forKey: .ordinal)).flatMap(String.init)
            ?? container.decode(String.self, forKey: .ordinal)
        self.ordinalID = ordinalID
    }

}
