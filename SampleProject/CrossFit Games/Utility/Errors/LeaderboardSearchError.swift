//
//  LeaderboardSearchError.swift
//  CrossFit Games
//
//  Created by Malinka S on 2/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Error type to identify leaderboard search API errors
///
/// - athleteDoesntExist: Used to specify if an athlete doesn't exist
enum LeaderboardSearchError: Error {

    case athleteDoesntExist(description: String?)

    case athleteNotFound

}
