//
//  LeaderboardRequest.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/18/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

typealias DecodableLeaderboardPage = Decodable & LeaderboardPage

/// Leaderboard request that can be initialized with a `CustomLeaderboard` which contains the required selected filters.
final class LeaderboardRequest: RawRepresentable, Equatable {

    typealias RawValue = HTTPRequest

    // MARK: - Private Properties
    
    private let customLeaderboard: CustomLeaderboard

    private let searchCondition: LeaderboardSearchCondition

    // MARK: - Initialization
    
    init?(rawValue: RawValue) {
        return nil
    }

    init(customLeaderboard: CustomLeaderboard, searchCondition: LeaderboardSearchCondition = .page(pageIndex: 1)) {
        self.customLeaderboard = customLeaderboard
        self.searchCondition = searchCondition
    }

    // MARK: - Public Properties
    
    var rawValue: HTTPRequest {
        let url = CFEnvironmentManager.shared.currentGeneralEnvironment.baseURL
            .appendingPathComponent("competitions/api/v1/competitions")
            .appendingPathComponent(customLeaderboard.selectedControls.type)
            .appendingPathComponent(customLeaderboard.selectedControls.year)
            .appendingPathComponent("leaderboards")

        var body = customLeaderboard.requestBody
        switch searchCondition {
        case .athlete(athleteId: let athleteId):
            body["athlete"] = athleteId
        case .page(pageIndex: let pageIndex):
            body["page"] = String(pageIndex)
        }
        if let affiliateId = customLeaderboard.affiliate {
            body["affiliate"] = affiliateId
        }

        return HTTPRequest(url: url, method: .get, body: body, headers: nil, encoding: .urlEncoding, allowCaching: true)
    }

}

    // MARK: - Public Functions
    
func == (_ lhs: LeaderboardRequest, _ rhs: LeaderboardRequest) -> Bool {
    return lhs.rawValue.urlRequest?.url == lhs.rawValue.urlRequest?.url
}
