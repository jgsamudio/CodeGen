//
//  MultiselectLeaderboardFilterData.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/3/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Multiselect filter option.
struct MultiselectLeaderboardFilterData: LeaderboardFilterData {

    private enum CodingKeys: String, CodingKey {
        case code
        case selects
        case value
        case display
    }

    private enum SelectionCodingKeys: String, CodingKey {
        case value
        case display
        case regionalid
    }

    /// Selection element of a multiselect filter data response.
    struct Selection: Codable {

        /// Value of the selection for API requests.
        let value: String

        /// Display string to show the user.
        let display: String

        /// Regional ID for "fittest in region" filter.
        let regionalid: String?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: SelectionCodingKeys.self)

            value = try (try? container.decode(String.self, forKey: .value))
                ?? String(container.decode(Int.self, forKey: .value))
            display = try container.decode(String.self, forKey: .display)
            regionalid = try container.decodeIfPresent(String.self, forKey: .regionalid)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: SelectionCodingKeys.self)

            try container.encode(value, forKey: .value)
            try container.encode(display, forKey: .display)
            try container.encodeIfPresent(regionalid, forKey: .regionalid)
        }

    }

    let value: String

    let display: String

    /// Code of the filter (if any).
    let code: String?

    /// Available selection to filter from.
    let selects: [Selection]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        code = try container.decodeIfPresent(String.self, forKey: .code)
        selects = try container.decode([Selection].self, forKey: .selects)
        value = try (try? container.decode(String.self, forKey: .value))
            ?? String(container.decode(Int.self, forKey: .value))
        display = try container.decode(String.self, forKey: .display)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(code, forKey: .code)
        try container.encode(selects, forKey: .selects)
        try container.encode(value, forKey: .value)
        try container.encode(display, forKey: .display)
    }

}
