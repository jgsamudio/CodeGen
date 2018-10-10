//
//  MemberInfoAnalyticsProperties.swift
//  TheWing
//
//  Created by Paul Jones on 9/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Member info analytics properties
///
/// - photoFilled: True if member in cell's profile is filled
/// - headlineFilled: True if member in cell's headline field is filled
/// - industry: Industry listed in the member cell
/// - location: Location listed in the member cell
/// - offerCount: 0 through infinite
/// - askCount: 0 through infinite
/// - superMatch: True if member is a super match for user who performed action
enum MemberInfoAnalyticsProperties: String {
    case photoFilled = "Photo filled"
    case headlineFilled = "Headline filled"
    case industry = "Industry"
    case location = "Location"
    case offerCount = "Number of offers"
    case askCount = "Number of asks"
    case superMatch = "Super match"
}

// MARK: - AnalyticsIdentifiable
extension MemberInfoAnalyticsProperties: AnalyticsIdentifiable {
    
    // MARK: - Public Properties
    
    var analyticsIdentifier: String {
        return rawValue
    }
    
}
