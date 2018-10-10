//
//  NetworkAuthLoader.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Alamofire

/// Handles user authentication api calls.
final class NetworkAuthLoader: Loader, AuthLoader {

	// MARK: - Public Functions

    // MARK: - Public Functions
    
    /// Sign In a user with the given parameters.
    ///
    /// - Parameters:
    ///   - email: Email of the user.
    ///   - password: Password of the user.
    ///   - completion: Completion handler with a deserialized user.
    func signIn(email: String, password: String, completion: @escaping (_ result: Result<User>) -> Void) {
    
    // MARK: - Public Properties
    
        let parameters: Parameters = ["email": email,
                                      "password": password]

        let request = apiRequest(method: .post, endpoint: Endpoints.login, parameters: parameters)

        httpClient.perform(request: request) { (result: Result<AuthInfo>) in
            guard let token = result.value?.token else {
                let error = result.error ?? AuthAPIError.noTokenReturned
                completion(Result.failure(error))
                return
            }
            self.user(authToken: token, completion: completion)
        }
    }

    /// Resets a user's password with the given email.
    ///
    /// - Parameters:
    ///   - email: Email of the user.
    ///   - completion: Completion handler with a successful boolean.
    func resetPassword(email: String, completion: @escaping (_ result: Result<Bool>) -> Void) {

    }

    /// Gets a user object with the given parameters.
    ///
    /// - Parameters:
    ///   - authToken: auth token of the user.
    ///   - completion: Completion handler with a deserialized user.
    func user(authToken: String, completion: @escaping (_ result: Result<User>) -> Void) {
        sessionManager.authToken = authToken

        let request = apiRequest(method: .get, endpoint: Endpoints.user, parameters: nil)

        httpClient.perform(request: request) { (result: Result<User>) in
            if result.isSuccess {
                self.sessionManager.user = result.value
            }
            completion(result)
        }
    }
    
    /// Gets current user object.
    ///
    /// - Parameter completion: Completion handler with a deserialized user.
    func user(completion: @escaping (_ result: Result<User>) -> Void) {
        guard let authToken = sessionManager.authToken else {
            let error = AuthAPIError.invalidToken
            completion(Result.failure(error))
            return
        }
        
        user(authToken: authToken, completion: completion)
    }

}
