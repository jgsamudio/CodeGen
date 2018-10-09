//
//  AccessTokenRequest.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/21/17.
//  Copyright © Prolific Interactive. All rights reserved.
//

import Foundation
import Keys

struct AccessTokenRequest: Encodable {

    /// Request for granting access to the API in order to perform user-independent tasks, such as creating accounts.
    static let clientCredentials = AccessTokenRequest(clientId: CrossfitgamesKeys().clientID(),
                                                      clientSecret: CrossfitgamesKeys().clientSecret(),
                                                      grantType: "client_credentials",
                                                      username: nil,
                                                      password: nil)

    /// Returns authentication for a single user to access (for example) profile information of this user's account.
    ///
    /// - Parameters:
    ///   - userName: User name (= email) of the user.
    ///   - password: Password of the user.
    /// - Returns: Access token request that can be sent to Oauth API to grant access to the user's domain.
    static func userAccess(username: String, password: String) -> AccessTokenRequest {
        return AccessTokenRequest(clientId: CrossfitgamesKeys().clientID(),
                                  clientSecret: CrossfitgamesKeys().clientSecret(),
                                  grantType: "password",
                                  username: username,
                                  password: password)
    }

    /*
     "client_id": CrossfitgamesKeys().clientID(),
     "client_secret": CrossfitgamesKeys().clientSecret(),
     "grant_type": "client_credentials"
     */
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case grantType = "grant_type"
        case username
        case password
    }

    /// Client ID for the application.
    let clientId: String

    /// Client secret for the application.
    let clientSecret: String

    /// Grant type of the authentication request.
    let grantType: String

    /// User name when sending request via password grant.
    let username: String?

    /// Password when sending request via password grant.
    let password: String?

}
