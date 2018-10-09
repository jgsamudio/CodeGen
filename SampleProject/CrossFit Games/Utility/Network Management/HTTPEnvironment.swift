//
//  HTTPEnvironment.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/21/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

public typealias Headers = [String: String]

/// HTTP environment.
protocol HTTPEnvironment {

    /// Environment name (e.g. "QA", "Production")
    var title: String { get }

    /// Environment base URL.
    var baseURL: URL { get }

    /// Environment type (ex: Auth, General)
    var environmentType: EnvironmentType { get }

    var environmentName: EnvironmentName { get }

    var defaultHTTPHeaders: Headers { get }

    var profilePictureURL: URL! { get }

}

extension HTTPEnvironment {

    /// Default headers for the current HTTP environment
    var defaultHTTPHeaders: Headers {
        return [
            "Content-Type": "application/json; charset=utf-8"
        ]
    }

}
