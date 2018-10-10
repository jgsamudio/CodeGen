//
//  UserInfoAnalyticsIdentifiers.swift
//  TheWing
//
//  Created by Paul Jones on 9/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

enum UserInfoAnalyticsIdentifiers: String {
    case bookmarked = "Bookmarked"
    case going = "Going"
    case locked = "Locked"
    case waitlisted = "Waitlisted"
    case none = "None"
    case undefined = "Undefined"
    
    // MARK: - Initialization
    
    init(_ userInfo: UserInfo) {
        switch (userInfo.bookmarked, userInfo.going, userInfo.locked, userInfo.waitlisted) {
        case (true, _, _, _):
            self = .bookmarked
        case (_, true, _, _):
            self = .going
        case (_, _, true, _):
            self = .locked
        case (_, _, _, true):
            self = .waitlisted
        case (false, false, false, false):
            self = .none
        default:
            self = .undefined
        }
    }
    
}
