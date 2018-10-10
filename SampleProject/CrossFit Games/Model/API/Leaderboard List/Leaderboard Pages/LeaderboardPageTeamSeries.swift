//
//  LeaderboardPageTeamSeries.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Leaderboard page format for team series.
struct LeaderboardPageTeamSeries: LeaderboardPage, Decodable {

    private enum CodingKeys: String, CodingKey {
        case items = "leaderboardRows"
        case pagination
        case ordinals
    }

    private enum PaginationKeys: String, CodingKey {
        case pageIndex = "currentPage"
        case totalPageCount = "totalPages"
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

        items = try container.decode([LeaderboardListItemTeamSeries].self, forKey: .items)
        ordinals = try container.decode([LeaderboardOrdinal].self, forKey: .ordinals)
        pageIndex = try pagination.decode(Int.self, forKey: .pageIndex)
        totalPageCount = try pagination.decode(Int.self, forKey: .totalPageCount)
        totalNumberOfAthletes = try pagination.decode(Int.self, forKey: .totalNumberOfAthletes)
    }

}
