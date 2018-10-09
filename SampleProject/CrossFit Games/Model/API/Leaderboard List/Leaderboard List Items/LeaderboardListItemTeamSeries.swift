//
//  LeaderboardListItemTeamSeries.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Leaderboard list item for the team series.
struct LeaderboardListItemTeamSeries: LeaderboardListItem, Decodable {

    private enum CodingKeys: String, CodingKey {
        case scores
        case entrant
        case roster
        case rank = "overallRank"
        case points = "overallScore"
    }

    let scores: [WorkoutScore]

    let user: LeaderboardAthlete

    /// Athletes that are part of this team.
    let roster: [LeaderboardAthlete]?

    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            scores = try container.decode([TeamSeriesWorkoutScore].self, forKey: .scores)
            var user = try container.decode(BasicLeaderboardAthlete.self, forKey: .entrant)
            roster = try container.decodeIfPresent([BasicLeaderboardAthlete].self, forKey: .roster)
            if let rank = try container.decodeIfPresent(String.self, forKey: .rank) {
                user.rank = rank
            }
            if let points = try container.decodeIfPresent(String.self, forKey: .points) {
                user.points = points
            }
            self.user = user

        } catch {
            throw error
        }
    }

}
