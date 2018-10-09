//
//  LeaderboardAthvare.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Athlete in a leaderboard list.
protocol LeaderboardAthlete {

    /// The athlete's ID.
    var userId: String { get }

    /// The athletes full name.
    var name: String? { get }

    /// Height of the athlete (textual representation with potentially different measurement units).
    var height: String? { get }

    /// Weight of the athlete (textual representation with potentially different measurement units).
    var weight: String? { get }

    /// The athlete's age.
    var age: Int? { get }

    /// The athlete's division ID.
    var divisionId: String? { get }

    /// The athlete's affiliate ID.
    var affiliateId: String? { get }

    /// The athlete's region ID.
    var regionId: String? { get }

    /// The athlete's region.
    var region: String? { get }

    /// The athlete's profile picture.
    var profilePic: URL? { get }

    /// The athlete's overall rank (not necessarily equal to index in athlete list, as this may be sorted by a different workout).
    var rank: String? { get }

    /// The athlete's overall points.
    var points: String? { get }

}
