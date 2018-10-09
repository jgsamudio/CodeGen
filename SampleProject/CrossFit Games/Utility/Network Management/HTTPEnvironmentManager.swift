//
//  HTTPEnvironmentManager.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/21/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

protocol HTTPEnvironmentManager {
    /// The current HTTP environment.
    var currentGeneralEnvironment: HTTPEnvironment! { get }

    /// The current Auth HTTP environment.
    var currentAuthEnvironment: HTTPEnvironment! { get }

    /// All the available HTTP environments.
    var environments: [String: HTTPEnvironment] { get }
}
