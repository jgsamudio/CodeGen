//
//  LeaderboardSearchService.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/22/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

final class LeaderboardSearchService {

    /// HTTP client for network communication.
    let httpClient: HTTPClientProtocol

    /// Creates a leaderboard filter service to generate filters.
    ///
    /// - Parameters:
    ///   - httpClient: HTTP client used for network communication.
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    /// Retrieves leaderboard filters for the given year and competition.
    ///
    /// - Parameters:
    ///   - competition: Competition for which to get the leaderboard filters.
    ///   - year: Year for which to get the leaderboard filters.
    ///   - completion: Completion block for the response.
    func getLeaderboardFilters(text: String, customLeaderBoard: CustomLeaderboard, completion: @escaping ([LeaderboardSearch]?, Error?) -> Void) {
        let competition = customLeaderBoard.selectedControls.type
        let year = customLeaderBoard.selectedControls.year
        let url = CFEnvironmentManager.shared.currentGeneralEnvironment.baseURL
            .appendingPathComponent("competitions/api/v1/competitions/\(competition)/\(year)/athletes")
        var body = customLeaderBoard.requestBody
        body["term"] = text
        let request = HTTPRequest(url: url,
                                  method: .get,
                                  body: body,
                                  headers: nil,
                                  encoding: .urlEncoding,
                                  allowCaching: true)

        httpClient.requestJson(request: request, isAuthRequest: false) { (searchList: [LeaderboardSearch]?, _, error) in
            completion(searchList, error)
        }
    }

}
