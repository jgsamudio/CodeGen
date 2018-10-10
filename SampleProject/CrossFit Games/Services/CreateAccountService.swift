//
//  UserRegistrationService.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/20/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

private struct CreateAccountRequest: Encodable {

    // MARK: - Public Properties
    
    /// Email of the user.
    let email: String

    /// The user's selected password.
    let password: String

    /// First name of the user.
    let first: String

    /// Last name of the user.
    let last: String

}

struct CreateAccountService {

    let httpClient: HTTPClientProtocol
    let userDataStore: UserDataStore

    // MARK: - Private Properties
    
    private let createAccountURL = "users"
    private let tokenRequestURL = "oauth2/token"

    // MARK: - Public Functions
    
    /// Creates user account
    ///
    /// - Parameters:
    ///   - email: email of the user
    ///   - password: password of the user
    ///   - firstName: first name of the user
    ///   - lastName: last name of the user
    ///   - completion: completion block which includes an auth error
    func createUserAccount(withEmail email: String,
                           password: String,
                           firstName: String,
                           lastName: String,
                           completion: @escaping (Error?) -> Void) {
        /// requests for the access token for non signed-in user
        getAccessTokenForClientCredentials(completion: { (response, error) in
            if error != nil {
                completion(error)
            } else {
                /// if the request is successful, a token is received, which will be used
                /// to fulfill the create account request.
                if let token = response?.accessToken {
                    let requestURL = CFEnvironmentManager.shared.currentAuthEnvironment.baseURL.appendingPathComponent(self.createAccountURL)
                    let request = HTTPRequest(url: requestURL,
                                              method: .post,
                                              body: CreateAccountRequest(email: email,
                                                                         password: password,
                                                                         first: firstName,
                                                                         last: lastName),
                                              headers: ["Content-Type": "application/x-www-form-urlencoded",
                                                        "Authorization": "Bearer \(token)"],
                                              encoding: .urlEncoding)
                    self.httpClient.requestJson(request: request, isAuthRequest: true) { (_: CreateAccountResponse?, statusCode, error) in
                        if let statusCode = statusCode {
                            /// Server returns 200 if the account already exists and the password matches
                            /// Server returns 401 if the account exists and password is invalid
                            if statusCode == 200 || statusCode == 401 {
                                completion(AuthError.accountExists)
                            /// Server returns 201, if an account is successfully created
                            } else if statusCode == 201 {
                                completion(nil)
                            } else {
                                completion(error)
                            }
                        } else {
                            completion(error)
                        }
                    }
                } else {
                    completion(error)
                }
            }
        })
    }

    /// Gets access token for client credentials
    ///
    /// - Parameter completion: completion block which incudes the response and the error.
    func getAccessTokenForClientCredentials(completion: @escaping (AccessTokenResponse?, Error?) -> Void) {
        let requestURL = CFEnvironmentManager.shared.currentAuthEnvironment.baseURL.appendingPathComponent(tokenRequestURL)
        let request = HTTPRequest(url: requestURL,
                                  method: .post,
                                  body: AccessTokenRequest.clientCredentials,
                                  headers: ["Content-Type": "application/json"],
                                  encoding: .json)
        httpClient.requestJson(request: request, isAuthRequest: true) { (response: AccessTokenResponse?, _, error)  in
            if error != nil {
                if response?.error == ErrorCode.invalidGrant.rawValue {
                    completion(nil, AuthError.credentialsInvalid)
                } else {
                    completion(nil, error)
                }
            } else {
                completion(response, nil)
            }
        }
    }

    /// Saves user locally/in-memory to be used accross multiple screens
    ///
    /// - Parameters:
    ///   - firstName: first name of the user
    ///   - lastName: last name of the user
    ///   - email: email of the user
    func saveUserInLocalStore(withFirstName firstName: String?,
                              lastName: String?,
                              email: String?) {
        let user = User(firstName: firstName, lastName: lastName, email: email)
        userDataStore.createAccountUser = user
    }

    /// Reads locally saved user
    ///
    /// - Returns: locally saved user
    func readUserFromLocalStore() -> User? {
        return userDataStore.createAccountUser
    }

    /// Removes locally saved user
    func removeUserFromLocalStore() {
        userDataStore.createAccountUser = nil
    }

}
