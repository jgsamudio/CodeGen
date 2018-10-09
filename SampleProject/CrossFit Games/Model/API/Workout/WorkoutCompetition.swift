//
//  WorkoutCompetition.swift
//  CrossFit Games
//
//  Created by Malinka S on 1/29/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct WorkoutCompetition: Decodable {

    private enum CodingKeys: String, CodingKey {
        case identifier
        case name
        case year
        case type
        case startDate = "start_date"
        case endDate = "end_date"
    }

    /// Competition identifier
    let identifier: String

    /// Competition name
    let name: String

    /// Workout created time
    let year: String

    /// Competition start time
    let startDate: Date?

    /// Competition end time
    let endDate: Date?

    /// Type of competition
    let type: String

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            identifier = try values.decode(String.self, forKey: .identifier)
            name = try values.decode(String.self, forKey: .name)
            year = try values.decode(String.self, forKey: .year)
            let startDateString = try values.decode(String.self, forKey: .startDate)
            let endDateString = try values.decode(String.self, forKey: .endDate)
            type = try values.decode(String.self, forKey: .type)

            startDate = startDateString.toCurrentDate(dateFormatter: CustomDateFormatter.apiDateFormatter)
            endDate = endDateString.toCurrentDate(dateFormatter: CustomDateFormatter.apiDateFormatter)
        } catch {
            print(error)
            throw error
        }
    }

}
