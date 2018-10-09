//
//  LeaderboardListItemRegionals.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Leaderboard list item for the regionals competition.
struct LeaderboardListItemRegionals: LeaderboardListItem, Decodable {

    private enum CodingKeys: String, CodingKey {
        case scores
        case entrant
        case rank = "overallRank"
        case points = "overallScore"
    }

    // MARK: - Public Properties
    
    let scores: [WorkoutScore]

    let user: LeaderboardAthlete

    // MARK: - Initialization
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var user = try container.decode(BasicLeaderboardAthlete.self, forKey: .entrant)
        scores = try container.decode([ExtendedWorkoutScore].self, forKey: .scores)
        if let rank = try container.decodeIfPresentAllowInt(String.self, forKey: .rank) {
            user.rank = rank
        }
        if let points = try container.decodeIfPresentAllowInt(String.self, forKey: .points) {
            user.points = points
        }
        self.user = user
    }

}
