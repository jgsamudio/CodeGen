//
//  DateRange.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Date range
struct DateRange: Codable {

    private enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case endDate = "end_date"
    }

    /// Start date of the date range.
    let startDate: Date?

    /// End date of the date range.
    let endDate: Date?

    init(startDate: Date? = nil, endDate: Date? = nil) {
        self.startDate = startDate
        self.endDate = endDate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let startString = try container.decodeIfPresent(String.self, forKey: .startDate)
        startDate = startString.flatMap(CustomDateFormatter.apiDateFormatter.date)

        let endString = try container.decodeIfPresent(String.self, forKey: .endDate)
        endDate = endString.flatMap(CustomDateFormatter.apiDateFormatter.date)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(startDate.flatMap(CustomDateFormatter.apiDateFormatter.string), forKey: .startDate)
        try container.encodeIfPresent(endDate.flatMap(CustomDateFormatter.apiDateFormatter.string), forKey: .endDate)
    }

}
