//
//  SettingsSection.swift
//  TheWing
//
//  Created by Luna An on 8/2/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

// Enumerates all possible settings sections.
///
/// - notifications: Notifications.
/// - communications: Communications.
/// - logout: Log out.
enum SettingsSection: Int {
    case notifications = 0
    case communications
    case logout
    
    // MARK: - Public Properties
    
    /// All sections.
    static var allSections = [SettingsSection.notifications, .communications, .logout]
    
    /// Associated menu items.
    var associatedMenuItems: [SettingsItem] {
        switch self {
        case .notifications:
            return [.eventReminders(UserDefaults.standard.pushHappenings),
                    .announcements(UserDefaults.standard.pushAnnoucements)]
        case .communications:
            return [.rateAtAppStore, .contactUs]
        case .logout:
            return [.logout]
        }
    }
    
}
