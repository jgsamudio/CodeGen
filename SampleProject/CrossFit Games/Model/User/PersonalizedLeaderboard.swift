//
//  PersonalizedLeaderboard.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 12/12/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Contains Personalized Leaderboard informaiton
struct PersonalizedLeaderboard: Codable {

    private enum CodingKeys: String, CodingKey {
        case competitorId
        case competitorName
        case professionId
        case divisionName
        case wight
        case profilePicS3key
        case lastName
        case affiliateId
        case professionName
        case stateName
        case gender
        case height
        case bio
        case affiliateName
        case divisionId
        case countryName
        case regionId
        case firstName
        case teamName
        case competitionAge
        case teamId
        case regionName
        case countryId
        case age
        case stats
    }

    // MARK: - Public Properties
    
    let competitorId: Int
    let competitorName: String
    let professionId: Int?
    let divisionName: String?
    let wight: String?
    let profilePicS3key: String?
    let lastName: String?
    let affiliateId: Int?
    let professionName: String?
    let stateName: String?
    let gender: String?
    let height: String?
    let bio: String?
    let affiliateName: String?
    let divisionId: Int?
    let countryName: String?
    let regionId: Int?
    let firstName: String?
    let teamName: String?
    let competitionAge: String?
    let teamId: Int?
    let regionName: String?
    let countryId: String?
    let age: String?
    let stats: PersonalizedLeaderboardStats?

    /// All Open competitions ordered descending by year.
    var mostRecentOpenCompetitions: [PersonalizedLeaderboardAllCompetitionResult] {
        return stats?.open?.sorted(by: { (lilBitOfThis, lilBitOfThat) -> Bool in
            lilBitOfThis.year.compare(lilBitOfThat.year) == .orderedDescending
        }) ?? []
    }

    /// Most recent Open competition.
    var mostRecentOpenCompetition: PersonalizedLeaderboardAllCompetitionResult? {
        return mostRecentOpenCompetitions.first
    }

    // MARK: - Public Functions
    
    /// Most recent competition which has started.
    func mostRecentStartedOpenCompetition(using competitionInfoService: CompetitionInfoService) -> PersonalizedLeaderboardAllCompetitionResult? {
        return mostRecentOpenCompetitions.first(where: { (result) -> Bool in
            guard let startDate = competitionInfoService
                .startDate(for: Competition.open.searchQueryString,
                           in: result.year) else {
                            return false
            }

            return startDate <= Date()
        })
    }

    /// Indicates whether `self` has invalid data.
    var isInvalid: Bool {
        let nextMostRecentOpenCompetition = mostRecentOpenCompetitions.dropFirst().first
        let nextMostRecentOpenInvalid = nextMostRecentOpenCompetition != nil && nextMostRecentOpenCompetition?.worldWide == nil
        return mostRecentOpenCompetition != nil && mostRecentOpenCompetition?.worldWide == nil && !nextMostRecentOpenInvalid
    }

    // MARK: - Initialization
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        competitorId = try container.decodeIfPresentAllowString(Int.self, forKey: .competitorId) ?? 0
        professionId = try container.decodeIfPresentAllowString(Int.self, forKey: .professionId)
        competitorName = try container.decode(String.self, forKey: .competitorName)
        divisionName = try container.decodeIfPresent(String.self, forKey: .divisionName)
        wight = try container.decodeIfPresent(String.self, forKey: .wight)
        profilePicS3key = try container.decodeIfPresent(String.self, forKey: .profilePicS3key)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        affiliateId = try container.decodeIfPresentAllowString(Int.self, forKey: .affiliateId)
        professionName = try container.decodeIfPresent(String.self, forKey: .professionName)
        stateName = try container.decodeIfPresent(String.self, forKey: .stateName)
        gender = try container.decodeIfPresent(String.self, forKey: .gender)
        height = try container.decodeIfPresentAllowInt(String.self, forKey: .height)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
        affiliateName = try container.decodeIfPresent(String.self, forKey: .affiliateName)
        divisionId = try container.decodeIfPresentAllowString(Int.self, forKey: .divisionId)
        countryName = try container.decodeIfPresent(String.self, forKey: .countryName)
        regionId = try container.decodeIfPresentAllowString(Int.self, forKey: .regionId)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        teamName = try container.decodeIfPresent(String.self, forKey: .teamName)
        countryId = try container.decodeIfPresentAllowInt(String.self, forKey: .countryId)
        age = try container.decodeIfPresentAllowInt(String.self, forKey: .age)
        stats = try container.decodeIfPresent(PersonalizedLeaderboardStats.self, forKey: .stats)
        competitionAge = try container.decodeIfPresentAllowInt(String.self, forKey: .competitionAge)
        teamId = try container.decodeIfPresentAllowString(Int.self, forKey: .teamId)
        regionName = try container.decodeIfPresent(String.self, forKey: .regionName)
    }

}
