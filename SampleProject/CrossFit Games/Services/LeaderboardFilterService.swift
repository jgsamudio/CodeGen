//
//  LeaderboardFilterService.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/10/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

final class LeaderboardFilterService {

    /// HTTP client for network communication.
    let httpClient: HTTPClientProtocol

    /// Competition info service to update competition info when filters are downloaded.
    let competitionInfoService: CompetitionInfoService

    /// Creates a leaderboard filter service to generate filters.
    ///
    /// - Parameters:
    ///   - httpClient: HTTP client used for network communication.
    init(competitionInfoService: CompetitionInfoService, httpClient: HTTPClientProtocol) {
        self.competitionInfoService = competitionInfoService
        self.httpClient = httpClient
    }

    /// Retrieves leaderboard filters for the given year and competition.
    ///
    /// - Parameters:
    ///   - competition: Competition for which to get the leaderboard filters.
    ///   - year: Year for which to get the leaderboard filters.
    ///   - completion: Completion block for the response.
    func getLeaderboardFilters(completion: @escaping ([LeaderboardControls]?, Error?) -> Void) {
        let url = CFEnvironmentManager.shared.currentGeneralEnvironment.baseURL
            .appendingPathComponent("competitions/api/v1/competitions")
        let request = HTTPRequest(url: url, method: .get,
                                  body: ["expand[]": "controls"],
                                  headers: nil,
                                  encoding: HTTPEncoding.urlEncoding,
                                  allowCaching: true)

        httpClient.requestJson(request: request, isAuthRequest: false) { (controls: [LeaderboardControls]?, _, error) in
            if let controls = controls {
                self.competitionInfoService.update(using: controls)
            }
            completion(controls?.filter { $0.parentCompetitionId?.isEmpty ?? true }, error)
        }
    }

}
