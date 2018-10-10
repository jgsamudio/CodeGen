//
//  DeepLinkKeys.swift
//  TheWing
//
//  Created by Luna An on 5/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Hashing keys for deep link data dictionary.
///
/// - edp: Event identifier.
/// - announcement: Announcement identifier.
/// - destination: Destination path.
/// - deeplinkPath: Deeplink path.
/// - clickedBranchLink: Clicked branch link.
enum DeepLinkKeys: String {
    case edp = "event_id"
    case announcement = "announcement_id"
    case destination = "destination"
    case deeplinkPath = "$deeplink_path"
    case clickedBranchLink = "+clicked_branch_link"
}
