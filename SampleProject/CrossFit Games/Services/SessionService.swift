//
//  SessionService.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 12/20/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Service for any things session related (i.e.: login state of a user, status of access tokens,
/// refreshing sessions).
struct SessionService {

    /// Data store to get user login information from.
    let userDataStore: UserDataStore

    /// Data store to interact with the keychain.
    let keychainDataStore: KeychainDataStore

    /// HTTP client for token refresh calls.
    let httpClient: HTTPClientProtocol

    private let tokenRequestURL = "oauth2/token"

    /// Indicates whether the user is currently logged in, meaning: whether the user
    /// information has been saved. A user can be logged in but the session expired.
    /// In this case, the session would have to be refreshed when accessing an
    /// endpoint that requires authentication.
    ///
    /// You can check whether a session is active via `isSessionActive`.
    ///
    /// Skipping login on app launch forces this to become false.
    var isLoggedIn: Bool {
        return userDataStore.detailedUser != nil
    }

    /// Indicates whether the user's session can be refreshed. This is only the case
    /// if the user opted to save their name and password by choosing "remember me".
    ///
    /// A session will only have to be refreshed when `isSessionActive` is false.
    var canRefreshSession: Bool {
        return keychainDataStore.value(for: .username) != nil
            && keychainDataStore.value(for: .password) != nil
    }

    /// Indicates whether the session is currently active, that is: whether the currently
    /// saved access token's expiration date lies in the future.
    var isSessionActive: Bool {
        guard let date = UserDefaultsManager.shared.getValue(byKey: .accessTokenExpirationDate) as? Date else {
            return false
        }

        return date.timeIntervalSinceNow > 0
    }

    /// Refreshes the current session if needed.
    ///
    /// - Parameters:
    ///   - email: User email for session refresh.
    ///   - password: Password for session refresh.
    ///   - completion: Completion block called with any errors or nil, if successful.
    func refreshSessionIfNeeded(email: String, password: String, completion: @escaping (Error?) -> Void) {
        guard !isSessionActive
            || keychainDataStore.value(for: .username) != email
            || keychainDataStore.value(for: .password) != password else {
                completion(nil)
                return
        }

        refreshSession(email: email, password: password, completion: completion)
    }

    /// Refreshes the current session even if the currently saved access token is assumed to be still valid.
    ///
    /// - Parameters:
    ///   - email: User email for session refresh.
    ///   - password: Password for session refresh.
    ///   - completion: Completion block called with any errors or nil, if successful.
    func refreshSession(email: String, password: String, completion: @escaping (Error?) -> Void) {
        let requestURL = CFEnvironmentManager.shared.currentAuthEnvironment.baseURL.appendingPathComponent(tokenRequestURL)
        let request = HTTPRequest(url: requestURL,
                                  method: .post,
                                  body: AccessTokenRequest.userAccess(username: email, password: password),
                                  headers: ["Content-Type": "application/json"],
                                  encoding: .json)
        httpClient.requestJson(request: request, isAuthRequest: true) { (response: AccessTokenResponse?, _, error)  in
            if error != nil {
                if response?.error == ErrorCode.invalidGrant.rawValue {
                    completion(AuthError.credentialsInvalid)
                } else {
                    completion(error)
                }
            } else {
                UserDefaultsManager.shared.setValue(withKey: UserDefaultsKey.userAccessToken,
                                                    value: response?.accessToken)
                UserDefaultsManager.shared.setValue(withKey: UserDefaultsKey.accessTokenExpirationDate,
                                                    value: (response?.expiresIn).flatMap { Date(timeIntervalSinceNow: TimeInterval($0)) })
                completion(nil)
            }
        }
    }

}
