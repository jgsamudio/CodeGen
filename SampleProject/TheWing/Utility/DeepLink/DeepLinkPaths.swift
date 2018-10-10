//
//  DeepLinkPaths.swift
//  TheWing
//
//  Created by Ruchi Jain on 9/19/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Different paths for routing.
///
/// - home: Home tab.
/// - happenings: Happenings tab.
/// - community: Community tab.
/// - myHappenings: My happenings.
/// - myBookmarks: Bookmarked happenings.
/// - profile: My profile.
/// - announcements: Announcements.
enum DeepLinkPaths: String {
    case home
    case happenings
    case community
    case myHappenings = "myhappenings"
    case myBookmarks = "mybookmarks"
    case profile
    case announcements
}
