//
//  BasicLeaderboardAthlete.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

struct BasicLeaderboardAthlete: LeaderboardAthlete, Decodable {

    private enum CodingKeys: String, CodingKey {
        case affiliateId
        case age
        case divisionId
        case height
        case region = "regionCode"
        case name = "competitorName"
        case profilePic = "profilePicS3key"
        case regionId
        case userId = "competitorId"
        case weight
        case rank = "overallRank"
        case points = "overallScore"
    }

    // MARK: - Public Properties
    
    let affiliateId: String?

    let age: Int?

    let divisionId: String?

    let height: String?

    let region: String?

    let name: String?

    let profilePic: URL?

    let regionId: String?

    let userId: String

    let weight: String?

    var points: String?

    var rank: String?

    // MARK: - Initialization
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        do {
            affiliateId = try container.decodeIfPresent(Int.self, forKey: .affiliateId).flatMap { "\($0)" }
        } catch DecodingError.typeMismatch(_, _) {
            affiliateId = try container.decodeIfPresent(String.self, forKey: .affiliateId)
        }
        do {
            regionId = try container.decodeIfPresent(Int.self, forKey: .regionId).flatMap { "\($0)" }
        } catch DecodingError.typeMismatch(_, _) {
            regionId = try container.decodeIfPresent(String.self, forKey: .regionId)
        }
        if let age = try container.decodeIfPresentAllowString(Int.self, forKey: .age), age > 0 {
            self.age = age
        } else {
            self.age = nil
        }
        region = try container.decodeIfPresent(String.self, forKey: .region)
        divisionId = try container.decodeIfPresent(String.self, forKey: .divisionId)
        height = try container.decodeIfPresent(String.self, forKey: .height)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        profilePic = try container.decodeIfPresent(String.self, forKey: .profilePic).flatMap({ (awsId) -> URL? in
            CFEnvironmentManager.shared.currentGeneralEnvironment.profilePictureURL.appendingPathComponent(awsId)
        })
        userId = try (try? "\(container.decode(Int.self, forKey: .userId))")
            ?? container.decode(String.self, forKey: .userId)
        weight = try container.decodeIfPresent(String.self, forKey: .weight)
        rank = try container.decodeIfPresent(String.self, forKey: .rank)
        points = try container.decodeIfPresent(String.self, forKey: .points)
    }

}
