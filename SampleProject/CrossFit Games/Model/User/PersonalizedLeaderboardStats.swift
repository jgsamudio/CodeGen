//
//  PersonalizedLeaderboardStats.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct PersonalizedLeaderboardStats: Codable {

    // MARK: - Public Properties
    
    let allStateRank: Bool?
    let hasStateRank: Bool?
    let open: [PersonalizedLeaderboardAllCompetitionResult]?

}
