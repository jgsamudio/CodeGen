//
//  MyHappeningsType.swift
//  TheWing
//
//  Created by Jonathan Samudio on 7/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Type of the my happenings view.
///
/// - myHappenings: Displays all of the user's current happenings.
/// - bookmarkedHappenings: Displays all of the user's bookmarked happenings.
enum MyHappeningsType {
    case myHappenings
    case bookmarkedHappenings

    // MARK: - Public Properties
    
    /// Flag to determine if the view should only load rsvpd events.
    var rsvpOnly: Bool? {
        switch self {
        case .myHappenings:
            return true
        default:
            return nil
        }
    }

    /// Flag to determine if the view should only load bookmarked events.
    var bookmarksOnly: Bool? {
        switch self {
        case .bookmarkedHappenings:
            return true
        default:
            return nil
        }
    }
    
    /// Flag to determine if the view should only load waitlisted events.
    var waitlistedFilter: Bool? {
        switch self {
        case .myHappenings:
            return true
        default:
            return nil
        }
    }

    // MARK: - Public Functions
    
    /// The happenings count for the current type.
    ///
    /// - Parameter eventCache: Local event cache.
    /// - Returns: Total event count.
    func happeningsCount(eventCache: EventLocalCache) -> Int {
        switch self {
        case .myHappenings:
            return eventCache.totalCount
        case .bookmarkedHappenings:
            return eventCache.bookmarkTotalCount
        }
    }

    /// Navigation title of the view controller.
    ///
    /// - Parameter happeningsCount: Total count of the happenings.
    /// - Returns: Formatted navigation title.
    func navigationTitle(happeningsCount: Int) -> String {
        return HomeLocalization.navigationTitle(forType: self, andHappeningsCount: happeningsCount)
    }

}
