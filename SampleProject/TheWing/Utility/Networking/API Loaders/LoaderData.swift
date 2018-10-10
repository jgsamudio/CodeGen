//
//  LoaderData.swift
//  TheWing
//
//  Created by Jonathan Samudio on 7/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct LoaderData {

    // MARK: - Public Properties
    
    /// Network HTTP Client.
    let httpClient: HTTPClient

    /// Mock HTTP Client.
    let mockHTTPClient: MockHTTPClient

    /// Current api environment.
    let apiEnvironment: APIEnvironment

    /// Session manager for the application.
    let sessionManager: SessionManager

    /// Local cache for events.
    let eventLocalCache: EventLocalCache
    
}
