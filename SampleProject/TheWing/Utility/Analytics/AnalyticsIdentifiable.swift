//
//  AnalyticsIdentifiable.swift
//  TheWing
//
//  Created by Paul Jones on 8/13/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// A protocol for an entity that can be identified by analytics.
protocol AnalyticsIdentifiable {
    
    /// How do you identify the implementor to the analytics provider?
    var analyticsIdentifier: String { get }
    
}

