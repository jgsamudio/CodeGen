//
//  LeaderboardFilterData.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/3/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Data contained in the common `data` array in leaderboard filter responses.
struct DefaultLeaderboardFilterData: LeaderboardFilterData, Codable {

    private enum CodingKeys: String, CodingKey {
        case value
        case display
    }

    let value: String

    let display: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        value = try (try? container.decode(String.self, forKey: .value))
            ?? String(container.decode(Int.self, forKey: .value))
        display = try container.decode(String.self, forKey: .display)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(value, forKey: .value)
        try container.encode(display, forKey: .display)
    }

}
