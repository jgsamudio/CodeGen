//
//  TabDestination.swift
//  TheWing
//
//  Created by Luna An on 5/7/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Enumerates tab destinations.
///
/// - home: Home.
/// - happenings: Happenings.
/// - community: Community.
enum TabDestination: Int {
    case home
    case happenings
    case community
}

// MARK: - AnalyticsIdentifiable
extension TabDestination: AnalyticsIdentifiable {
    
    // MARK: - Public Properties
    
    var analyticsIdentifier: String {
        switch self {
        case .home:
            return AnalyticsScreen.home.analyticsIdentifier
        case .happenings:
            return AnalyticsScreen.events.analyticsIdentifier
        case .community:
            return AnalyticsScreen.community.analyticsIdentifier
        }
    }
    
}
