//
//  LeaderboardAthleteResultCellViewModel.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/25/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// View model for a leaderboard athlete result cell.
struct LeaderboardAthleteResultCellViewModel: Codable {

    /// Athlete ID
    let id: String
    
    /// Athlete name.
    let name: String?

    /// Image URLs for athletes.
    let imageUrls: [URL]?

    /// Athlete's age.
    let age: String?

    /// Region the athlete is from.
    let region: String?

    /// The athlete's rank.
    let rank: String?

    /// The athlete's height.
    let height: String?

    /// The athlete's weight.
    let weight: String?

    /// The athlete's points.
    let points: String?

    /// Names of workouts.
    let workoutNames: [String]

    /// Ranks for the different workouts.
    let ranks: [String]

    /// Scores of different workouts.
    let scores: [String]

    /// Score to display in the UI on secondary label.
    let displayScore: String?

    /// Workout service
    var followAnAthleteService: FolllowAnAthleteService

    /// User auth service
    var userAuthService: UserAuthService

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrls
        case age
        case region
        case rank
        case height
        case weight
        case points
        case workoutNames
        case ranks
        case scores
        case displayScore
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        imageUrls = try values.decodeIfPresent([URL].self, forKey: .imageUrls)
        age = try values.decodeIfPresent(String.self, forKey: .age)
        region = try values.decodeIfPresent(String.self, forKey: .region)
        rank = try values.decodeIfPresent(String.self, forKey: .rank)
        height = try values.decodeIfPresent(String.self, forKey: .height)
        weight = try values.decodeIfPresent(String.self, forKey: .weight)
        points = try values.decodeIfPresent(String.self, forKey: .points)
        workoutNames = try values.decode([String].self, forKey: .workoutNames)
        ranks = try values.decode([String].self, forKey: .ranks)
        scores = try values.decode([String].self, forKey: .scores)
        displayScore = try values.decodeIfPresent(String.self, forKey: .displayScore)
        followAnAthleteService = ServiceFactory.shared.createFollowAnAthleteService()
        userAuthService = ServiceFactory.shared.createUserAuthService()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(imageUrls, forKey: .imageUrls)
        try container.encode(age, forKey: .age)
        try container.encodeIfPresent(region, forKey: .region)
        try container.encode(rank, forKey: .rank)
        try container.encode(height, forKey: .height)
        try container.encodeIfPresent(weight, forKey: .weight)
        try container.encodeIfPresent(points, forKey: .points)
        try container.encodeIfPresent(workoutNames, forKey: .workoutNames)
        try container.encodeIfPresent(ranks, forKey: .ranks)
        try container.encodeIfPresent(scores, forKey: .scores)
        try container.encodeIfPresent(displayScore, forKey: .displayScore)
    }

    init(id: String, name: String?, imageUrls: [URL]?,
         age: String?, region: String?, rank: String?,
         height: String?, weight: String?, points: String?,
         workoutNames: [String], ranks: [String], scores: [String], displayScore: String?) {
        followAnAthleteService = ServiceFactory.shared.createFollowAnAthleteService()
        userAuthService = ServiceFactory.shared.createUserAuthService()
        self.id = id
        self.name = name
        self.imageUrls = imageUrls
        self.age = age
        self.region = region
        self.rank = rank
        self.height = height
        self.weight = weight
        self.points = points
        self.workoutNames = workoutNames
        self.ranks = ranks
        self.scores = scores
        self.displayScore = displayScore
    }

    /// Flag to specify if the logged in user, is the viewing athlete
    var isCurrentUser: Bool {
        if let userId = userAuthService.userDataStore.detailedUser?.userId,
            self.id == userId {
            return true
        }
        return false
    }

    /// Gets the saved athlete
    ///
    /// - Returns: Athlete Id
    func getFollowingAthlete() -> String? {
        return followAnAthleteService.getFollowingAthleteId()
    }

}
