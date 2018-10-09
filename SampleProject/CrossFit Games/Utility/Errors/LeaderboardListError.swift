//
//  LeaderboardListError.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Errors related to loading a leaderboard list.
enum LeaderboardListError: Error {

    /// Error thrown when encountering a leaderboard list type that is not supported by the app.
    case unknownLeaderboardItemType(decoder: Decoder, keyPath: [CodingKey])

}
