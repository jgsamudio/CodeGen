//
//  OpenOnlineLeaderboardAthlete.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

struct OpenOnlineLeaderboardAthlete: LeaderboardAthlete, Decodable {

    private enum CodingKeys: String, CodingKey {
        case affiliateId = "affiliateid"
        case age
        case divisionId = "divisionid"
        case height
        case name
        case region = "region"
        case profilePic = "profilepic"
        case regionId = "regionid"
        case userId = "userid"
        case weight
        case rank = "overallrank"
        case points = "overallscore"
    }

    // MARK: - Public Properties
    
    let affiliateId: String?

    let age: Int?

    let divisionId: String?

    let height: String?

    let name: String?

    let profilePic: URL?

    let regionId: String?

    let region: String?

    let points: String?

    let userId: String

    let weight: String?

    let rank: String?

    // MARK: - Initialization
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let age = try container.decodeIfPresentAllowString(Int.self, forKey: .age), age > 0 {
            self.age = age
        } else {
            self.age = nil
        }

        region = try container.decodeIfPresent(String.self, forKey: .region)
        affiliateId = try container.decodeIfPresent(String.self, forKey: .affiliateId)
        divisionId = try container.decodeIfPresent(String.self, forKey: .divisionId)
        height = try container.decodeIfPresent(String.self, forKey: .height)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        profilePic = try container.decodeIfPresent(URL.self, forKey: .profilePic)
        regionId = try container.decodeIfPresent(String.self, forKey: .regionId)
        userId = try container.decode(String.self, forKey: .userId)
        weight = try container.decodeIfPresent(String.self, forKey: .weight)
        rank = try container.decodeIfPresent(String.self, forKey: .rank)
        points = try container.decodeIfPresent(String.self, forKey: .points)
    }

}
