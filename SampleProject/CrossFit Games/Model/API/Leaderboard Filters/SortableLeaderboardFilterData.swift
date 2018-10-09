//
//  SortableLeaderboardFilterData.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/3/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Filter data that provides additional sort/control options.
struct SortableLeaderboardFilterData: LeaderboardFilterData {

    private enum CodingKeys: String, CodingKey {
        case controls
        case value
        case display
    }

    // MARK: - Public Properties
    
    /// Controls by which the user can sort.
    let controls: [LeaderboardFilter]

    let value: String

    let display: String

    // MARK: - Initialization
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        value = try (try? container.decode(String.self, forKey: .value))
            ?? String(container.decode(Int.self, forKey: .value))
        display = try container.decode(String.self, forKey: .display)

        let controls = try container.decode([LeaderboardFilter].self, forKey: .controls)
        self.controls = controls
    }

    // MARK: - Public Functions
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(controls, forKey: .controls)
        try container.encode(value, forKey: .value)
        try container.encode(display, forKey: .display)
    }

}
