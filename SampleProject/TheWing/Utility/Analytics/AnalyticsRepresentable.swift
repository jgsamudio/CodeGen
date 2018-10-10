//
//  AnalyticsRepresentable.swift
//  TheWing
//
//  Created by Paul Jones on 8/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// A protocol for an entity that can represented to analytics.
protocol AnalyticsRepresentable {
    
    /// What properties do you want to send to the analytics provider?
    var analyticsProperties: [String: Any] { get }
    
}

extension AnalyticsRepresentable {
    
    // MARK: - Public Functions
    
    func analyticsProperties(forScreen screen: AnalyticsIdentifiable,
                             andAdditionalProperties additionalProperties: [String: Any]? = nil) -> [String: Any] {
    
    // MARK: - Public Properties
    
        var properties = analyticsProperties
        properties[AnalyticsConstants.screenName] = screen.analyticsIdentifier
        if let additionalProperties = additionalProperties {
            properties.merge(additionalProperties, uniquingKeysWith: { $1 })
        }
        return properties
    }
    
}
