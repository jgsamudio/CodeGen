//
//  LoginHTTPClient.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/26/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Alamofire
import Foundation

/// HTTP client to handle all the network requests except for auth requests,
/// which is bound with a custom auth manager
struct DefaultHTTPClient: HTTPClientProtocol {

    let sessionManager: SessionManager

    private let adapter = DefaultRequestAdapter()

    init(sessionManager: SessionManager) {
        sessionManager.adapter = adapter
        self.sessionManager = sessionManager
    }

}
