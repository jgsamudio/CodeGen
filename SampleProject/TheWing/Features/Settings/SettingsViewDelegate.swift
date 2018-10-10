//
//  SettingsViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 8/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol SettingsViewDelegate: class {

    /// Toggles happenings reminders notification.
    ///
    /// - Parameter isOn: Flag to determine if the notification should be on or off.
    func toggleHappeningsRemindersNotification(_ isOn: Bool)
    
    /// Toggles announcements notification.
    ///
    /// - Parameter isOn: Flag to determine if the notification should be on or off.
    func toggleAnnouncementsNotification(_ isOn: Bool)
    
    /// Called to indicate that user selected rate us at the app store.
    func rateUsAtTheAppStoreSelected()
    
    /// Called to indicate that user selected contact us.
    ///
    /// - Parameter url: URL to open.
    func contactUsSelected(email: String)
    
    /// Called to indicate that user selected log out.
    func logOutSelected()
    
}
