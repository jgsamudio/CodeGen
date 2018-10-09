//
//  PersonalizedLeaderboardAllCompetitionResult.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct PersonalizedLeaderboardAllCompetitionResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case year
        case divisionId
        case divisionName
        case teamName
        case teamId
        case regionId
        case currentPage
        case affiliateId
        case totalPages
        case affiliateName
        case region
        case worldWide
        case byState
        case byRegion
        case byAffiliate
    }

    let year: String
    let divisionId: Int
    let divisionName: String
    let teamName: String?
    let teamId: Int?
    let regionId: Int?
    let currentPage: Int?
    let affiliateId: Int?
    let totalPages: Int?
    let affiliateName: String?
    let region: String?
    let worldWide: PersonalizedLeaderboardSingleCompetitionResult?
    let byState: PersonalizedLeaderboardSingleCompetitionResult?
    let byRegion: PersonalizedLeaderboardSingleCompetitionResult?
    let byAffiliate: PersonalizedLeaderboardSingleCompetitionResult?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        year = try container.decodeIfPresentAllowInt(String.self, forKey: .year) ?? ""
        divisionId = try container.decodeIfPresentAllowString(Int.self, forKey: .divisionId) ?? 0
        divisionName = try container.decodeIfPresent(String.self, forKey: .divisionName) ?? ""
        teamName = try container.decodeIfPresent(String.self, forKey: .teamName)
        teamId = try container.decodeIfPresentAllowString(Int.self, forKey: .teamId)
        regionId = try container.decodeIfPresentAllowString(Int.self, forKey: .regionId)
        currentPage = try container.decodeIfPresentAllowString(Int.self, forKey: .currentPage)
        affiliateId = try container.decodeIfPresentAllowString(Int.self, forKey: .affiliateId)
        totalPages = try container.decodeIfPresentAllowString(Int.self, forKey: .totalPages)
        affiliateName = try container.decodeIfPresent(String.self, forKey: .affiliateName)
        region = try container.decodeIfPresent(String.self, forKey: .region)
        worldWide = try container.decodeIfPresent(PersonalizedLeaderboardSingleCompetitionResult.self, forKey: .worldWide)
        byState = try container.decodeIfPresent(PersonalizedLeaderboardSingleCompetitionResult.self, forKey: .byState)
        byRegion = try container.decodeIfPresent(PersonalizedLeaderboardSingleCompetitionResult.self, forKey: .byRegion)
        byAffiliate = try container.decodeIfPresent(PersonalizedLeaderboardSingleCompetitionResult.self, forKey: .byAffiliate)
    }

}
