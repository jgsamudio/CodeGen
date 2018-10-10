//
//  LeaderboardPageGamesRegionals.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Leaderboard page format for games and regionals.
struct LeaderboardPageGamesRegionals: LeaderboardPage, Decodable {

    private enum CodingKeys: String, CodingKey {
        case items = "leaderboardRows"
        case pagination
        case ordinals
    }

    private enum PaginationKeys: String, CodingKey {
        case pageIndex = "currentpage"
        case totalPageCount = "totalpages"
        case totalNumberOfAthletes = "totalCompetitors"
    }

    // MARK: - Public Properties
    
    let items: [LeaderboardListItem]

    let pageIndex: Int

    let totalPageCount: Int

    let totalNumberOfAthletes: Int

    var ordinals: [LeaderboardOrdinal]

    // MARK: - Initialization
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let pagination = try container.nestedContainer(keyedBy: PaginationKeys.self, forKey: .pagination)

        items = try (try? container.decode([LeaderboardListItemRegionals].self, forKey: .items))
            ?? (container.decode([LeaderboardListItemGames].self, forKey: .items))
        ordinals = try container.decode([LeaderboardOrdinal].self, forKey: .ordinals)
        pageIndex = try pagination.decode(Int.self, forKey: .pageIndex)
        totalPageCount = try pagination.decode(Int.self, forKey: .totalPageCount)
        let competitors = try pagination.decode(Int.self, forKey: .totalNumberOfAthletes)
        if competitors > 1 { // Current issue: athlete count coming back as 1
            totalNumberOfAthletes = competitors
        } else {
            totalNumberOfAthletes = items.count * totalPageCount
        }
    }

}
