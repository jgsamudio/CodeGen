//
//  CFEnvironment.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/22/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// A struct to represent an environment used in the
/// Crossfit application.
struct CFEnvironment: HTTPEnvironment {

    /// Title to be visualized in debug menu items
    let title: String

    /// Base URL of the environment
    let baseURL: URL

    /// Base URL to retrieve profile pictures.
    let profilePictureURL: URL! = URL(string: "https://profilepicsbucket.crossfit.com/")

    /// Environment type (auth, general)
    let environmentType: EnvironmentType

    /// Environment name (Authorization Beta, Authorixation Prod, Genral Prod)
    let environmentName: EnvironmentName

    let defaultHTTPHeaders: Headers = [:]

}
