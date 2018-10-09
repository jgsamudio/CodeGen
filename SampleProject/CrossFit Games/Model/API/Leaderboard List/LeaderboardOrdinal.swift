//
//  LeaderboardOrdinal.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/26/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Leaderboard ordinal, carrying information about workouts in a leaderboard list.
struct LeaderboardOrdinal: Codable {

    private enum CodingKeys: String, CodingKey {
        case id = "ordinal"
        case displayName = "columnName"
    }

    // MARK: - Public Properties
    
    /// ID of `self`.
    let id: String

    /// Display name of `self`.
    let displayName: String

}
