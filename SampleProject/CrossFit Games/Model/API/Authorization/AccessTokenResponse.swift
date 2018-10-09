//
//  AccessTokenResponse.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/21/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Response of an access token request.
struct AccessTokenResponse: Codable {

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case scope
        case refreshToken = "refresh_token"
        case error
        case errorDescription = "error_description"
    }

    /// Access token for future API access.
    let accessToken: String?

    /// Time (in seconds) until the given access token expires.
    let expiresIn: Int?

    /// Type of the token (Bearer for example).
    let tokenType: String?

    /// Scope defining what the request gave access to.
    let scope: String?

    /// Optional refresh token that can be used to renew the given access token after it expired.
    let refreshToken: String?

    /// Optional error code which will be in the error response
    let error: String?

    /// Optional error description, which comes with the error code
    let errorDescription: String?

}
