//
//  PersonalizedLeaderboardService.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 12/12/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

import Alamofire

/// Handles retrieving peresonalized leaderboard service
struct PersonalizedLeaderboardService {

    // MARK: - Public Properties
    
    let httpClient: HTTPClientProtocol

    let userID: String

    // MARK: - Public Functions
    
    /// Retrieves personalized leaderboard information
    ///
    /// - Parameters:
    ///   - completion: Handler holding detailed user information alongside any error information
    func retrievePersonalized(completion: @escaping (PersonalizedLeaderboard?, Error?) -> Void) {
        let httpRequest = HTTPRequest(url: CFEnvironmentManager.shared.currentGeneralEnvironment.baseURL
            .appendingPathComponent("competitions")
            .appendingPathComponent("api")
            .appendingPathComponent("v1")
            .appendingPathComponent("athlete")
            .appendingPathComponent(userID)) // The real deal

        httpClient.requestJson(request: httpRequest,
                               isAuthRequest: false) { (personalizedLeaderboard: PersonalizedLeaderboard?, _, error) in
                                guard let personalizedLeaderboard = personalizedLeaderboard else {
                                    completion(nil, error)
                                    return
                                }

                                completion(personalizedLeaderboard, nil)
        }
    }

}
