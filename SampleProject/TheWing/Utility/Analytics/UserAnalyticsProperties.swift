//
//  UserAnalyticsProperties.swift
//  TheWing
//
//  Created by Paul Jones on 8/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Represents the analytics properties of a user object
///
/// - location: The user's location
enum UserAnalyticsProperties: String {
    case location = "Location"
}

// MARK: - AnalyticsIdentifiable
extension UserAnalyticsProperties: AnalyticsIdentifiable {
    
    // MARK: - Public Properties
    
    var analyticsIdentifier: String {
        return rawValue
    }
    
}
