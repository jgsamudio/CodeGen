//
//  HTTPClient.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/21/17.
//  Copyright © Prolific Interactive. All rights reserved.
//

import Alamofire
import Foundation

/// HTTP client to handle all the auth related network requests
/// which includes a session manager who manages refreshing the token if it has expires as well
struct AuthHTTPClient: HTTPClientProtocol {

    /// Session Manager
    let sessionManager: SessionManager

    /// Manager handling OAuth
    let oAuthManager: OAuthManager

    /// Initalizes client
    ///
    /// - Parameter sessionManager: Session Manager to utilize
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        oAuthManager = OAuthManager(sessionManager: sessionManager)
    }

}
