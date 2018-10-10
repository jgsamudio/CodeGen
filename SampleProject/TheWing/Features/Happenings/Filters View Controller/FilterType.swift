//
//  FilterType.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Filter Type.
///
/// - events: Events Tab.
/// - community: Community Tab.
enum FilterType {
    case events
    case community
    case attendees(eventId: String)

    // MARK: - Public Properties
    
    /// Title of the filter view controller.
    var title: String {
        switch self {
        case .events:
            return "FILTER_EVENTS".localized(comment: "Filter events")
        case .community, .attendees:
            return "FILTER_COMMUNITY".localized(comment: "Filter Community")
        }
    }

    /// Key for the filters cache.
    var filterCacheKey: UserDefaultsKeyConvertible? {
        switch self {
        case .events:
            return UserDefaultsKeys.eventsFilters
        case .community:
            return UserDefaultsKeys.communityFilters
        case .attendees:
            return nil
        }
    }

    // MARK: - Public Functions
    
    /// Text to display the results.
    func showFiltersText(count: Int) -> String {
        switch self {
        case .events:
            return String(format: "SHOW_HAPPENINGS".localized(comment: "Show happenings"), "\(count)").uppercased()
        case .community, .attendees:
            return String(format: "SHOW_MEMBERS".localized(comment: "Show members"), "\(count)").uppercased()
        }
    }
    
}
