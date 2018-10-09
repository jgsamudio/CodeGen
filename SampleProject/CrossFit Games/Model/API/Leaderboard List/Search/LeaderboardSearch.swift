//
//  LeaderboardSearch.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/22/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

struct LeaderboardSearch: Codable {
    let identifier: String
    let name: String
    let firstname: String
    let lastname: String
    let affiliate: String

    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case firstname = "first_name"
        case lastname = "last_name"
        case affiliate
    }
}
