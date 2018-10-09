//
//  NotificationName.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 12/5/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Possible Notifications app posts
enum NotificationName: String {

    /// Triggered whenever Yoshi Date Picker is updated
    case yoshiDatePickerUpdated

    /// Refresh Data
    case refreshData

    /// Notifies if the app is launched
    case appDidBecomeActive

    /// Notifies the app when the user logged in.
    case userDidLogin

    /// Notifies if any changes occurred to the following athlete
    case followingAthleteDidUpdate

    /// Notification Name
    var name: Notification.Name {
        return Notification.Name(rawValue: rawValue)
    }

}
