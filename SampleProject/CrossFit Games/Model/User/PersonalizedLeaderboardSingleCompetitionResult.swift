//
//  PersonalizedLeaderboardSingleCompetitionResult.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct PersonalizedLeaderboardSingleCompetitionResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case rank
        case score
        case totalAthletes
        case totalPages
        case affiliateId
        case divisionId
        case currentPage
        case regionName
        case age
        case name
        case id
    }

    let rank: String?
    let score: Int?
    let totalAthletes: Int?
    let totalPages: Int?
    let affiliateId: Int?
    let divisionId: Int?
    let currentPage: Int?
    let regionName: String?
    let age: Int?
    let name: String?
    let id: Int?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        rank = try container.decodeIfPresentAllowInt(String.self, forKey: .rank)
        score = try container.decodeIfPresentAllowString(Int.self, forKey: .score)
        totalAthletes = try container.decodeIfPresentAllowString(Int.self, forKey: .totalAthletes)
        totalPages = try container.decodeIfPresentAllowString(Int.self, forKey: .totalPages)
        affiliateId = try container.decodeIfPresentAllowString(Int.self, forKey: .affiliateId)
        divisionId = try container.decodeIfPresentAllowString(Int.self, forKey: .divisionId)
        currentPage = try container.decodeIfPresentAllowString(Int.self, forKey: .currentPage)
        regionName = try container.decodeIfPresent(String.self, forKey: .regionName)
        age = try container.decodeIfPresentAllowString(Int.self, forKey: .age)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        id = try container.decodeIfPresentAllowString(Int.self, forKey: .id)
    }

}
