//
//  APIEnvironment.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/7/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Yoshi
import Alamofire

/// Contains information for a network environment.
struct APIEnvironment: Codable, YoshiEnvironment {

	// MARK: - Public Properties

    // MARK: - Public Properties
    
    /// Name of the environment.
    var name: String

    /// Base url to make api requsts from.
    var baseURL: URL
}
