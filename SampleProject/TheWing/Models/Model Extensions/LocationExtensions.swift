//
//  LocationExtensions.swift
//  TheWing
//
//  Created by Paul Jones on 8/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

// MARK: - AnalyticsIdentifiable
extension Location: AnalyticsIdentifiable {
    
    // MARK: - Public Properties
    
    var analyticsIdentifier: String {
        return name
    }
    
}
