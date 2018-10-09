//
//  LeaderboardListItemOpen.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Leaderboard list item for the open competition.
struct LeaderboardListItemOpen: LeaderboardListItem, Decodable {

    private enum CodingKeys: String, CodingKey {
        case scores
    }

    let scores: [WorkoutScore]

    let user: LeaderboardAthlete

    init(from decoder: Decoder) throws {
        user = try OpenOnlineLeaderboardAthlete(from: decoder)
        var scores = try decoder
            .container(keyedBy: CodingKeys.self)
            .decode([BasicWorkoutScore].self, forKey: .scores)
        for i in 0..<scores.count {
            scores[i].ordinalID = "\(i+1)"
        }
        self.scores = scores
    }

}
