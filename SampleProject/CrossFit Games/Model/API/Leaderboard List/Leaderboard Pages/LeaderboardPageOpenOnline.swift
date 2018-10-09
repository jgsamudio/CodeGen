//
//  LeaderboardPageOpenOnline.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Leaderboard page format for open and online qualifiers.
struct LeaderboardPageOpenOnline: LeaderboardPage, Decodable {

    private enum CodingKeys: String, CodingKey {
        case pageIndex = "currentpage"
        case totalPageCount = "totalpages"
        case items = "athletes"
    }

    // MARK: - Public Properties
    
    let items: [LeaderboardListItem]

    let pageIndex: Int

    let totalPageCount: Int

    var totalNumberOfAthletes: Int {
        // Estimating number of athletes based on the number of athletes in the current page & page count - to go away with API v3.
        return items.count * totalPageCount
    }

    var ordinals: [LeaderboardOrdinal]

    // MARK: - Initialization
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try (try? container.decode([LeaderboardListItemOpen].self, forKey: .items))
            ?? (container.decode([LeaderboardListItemOnlineQualifier].self, forKey: .items))
        pageIndex = try container.decode(Int.self, forKey: .pageIndex)
        totalPageCount = try container.decode(Int.self, forKey: .totalPageCount)
        ordinals = []
    }

}
