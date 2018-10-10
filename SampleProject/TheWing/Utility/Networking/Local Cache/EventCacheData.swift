//
//  EventCacheData.swift
//  TheWing
//
//  Created by Jonathan Samudio on 7/19/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct EventCacheData {

    // MARK: - Public Properties
    
    /// Flag to determine if the user is waitlisted.
    let userIsWaitlisted: Bool
    
    /// Flag to determine if the user is going.
    let userIsGoing: Bool

    /// Flag to determine if the event was cached locally.
    let changedLocally: Bool

    /// Cached event.
    let event: Event

    /// Bookmark Info.
    let bookmarkedInfo: BookmarkInfo

}
