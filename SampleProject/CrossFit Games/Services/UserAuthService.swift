//
//  UserService.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/25/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Consists of all the user authentication operations
struct UserAuthService {

    // MARK: - Public Properties
    
    let httpClient: HTTPClientProtocol
    let userDataStore: UserDataStore
    let authClient: AuthHTTPClient
    let keychainDataStore: KeychainDataStore

    let sessionService: SessionService

    // MARK: - Private Properties
    
    private let meRequestURL = "oauth2/me"

    // MARK: - Public Functions
    
    /// Authorizes user first and if successful, then gets detailed user information
    ///
    /// - Parameters:
    ///   - email: Email to supply for oauth token endpoint
    ///   - password: password to supply for oauth token endpoint
    ///   - completion: Handler holding detailed user information alongside any error information
    func retrieveDetailedUserWithAuth(withEmail email: String, password: String, completion: @escaping (DetailedUser?, Error?) -> Void) {
        sessionService.refreshSessionIfNeeded(email: email, password: password) { (error) in
            if let error = error {
                completion(nil, error)
            } else {
                self.retrieveUserInfo(completion: completion)
            }
        }
    }

    /// Initiates network request to me endpoint to attain detailed user information
    ///
    /// - Parameter completion: Handler holding detailed user information alongside any error information
    private func retrieveUserInfo(completion: @escaping (DetailedUser?, Error?) -> Void) {
        let requestURL = CFEnvironmentManager.shared.currentAuthEnvironment.baseURL.appendingPathComponent(meRequestURL)
        let request = HTTPRequest(url: requestURL,
                                  method: .get,
                                  body: nil,
                                  headers: nil,
                                  encoding: .json)
        authClient.requestJson(request: request, isAuthRequest: true) { (user: DetailedUser?, _, error)  in
            self.userDataStore.detailedUser = user
            completion(user, error)
            if error == nil {
                NotificationCenter.default.post(name: NotificationName.userDidLogin.name, object: nil)
            }
        }
    }

}
