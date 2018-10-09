//
//  LeaderboardPage.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// A single page in an entire leaderboard list.
protocol LeaderboardPage {

    /// Page index of `self`.
    var pageIndex: Int { get }

    /// Total number of pages.
    var totalPageCount: Int { get }

    /// Number of athletes in total.
    var totalNumberOfAthletes: Int { get }

    /// All items that are listed in `self`.
    var items: [LeaderboardListItem] { get }

    /// Ordinals available for `self`.
    var ordinals: [LeaderboardOrdinal] { get }

}
