//
//  SettingsItem.swift
//  TheWing
//
//  Created by Luna An on 8/2/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

// Enumerates all possible settings items.
///
/// - eventReminders: Event Reminders.
/// - announcements: Announcements.
/// - rateAtAppStore: Rate Us at the App Store.
/// - contactUs: Contact Us.
/// - logout: Log Out.
enum SettingsItem {
    case eventReminders(Bool)
    case announcements(Bool)
    case rateAtAppStore
    case contactUs
    case logout
    
    // MARK: - Public Properties
    
    /// Indicates if the settings item has a switch component.
    var hasSwitch: Bool {
        switch self {
        case .eventReminders, .announcements:
            return true
        default:
            return false
        }
    }
    
    /// Settings item title.
    var title: String {
        switch self {
        case .eventReminders:
            return SettingsLocalization.eventRemindersItemTitle
        case .announcements:
            return SettingsLocalization.announcementItemTitle
        case .rateAtAppStore:
            return SettingsLocalization.rateUsAtTheAppStoreItemTitle
        case .contactUs:
            return SettingsLocalization.contactUsItemTitle
        case .logout:
            return SettingsLocalization.logOutItemTitle
        }
    }
    
    /// Associated switch type if available.
    var switchType: SettingsSwitchType? {
        switch self {
        case .eventReminders:
            return .events
        case .announcements:
            return .announcements
        default:
            return nil
        }
    }
    
    /// Indicates if the switch for a reminder item is on/off.
    var isOn: Bool {
        switch self {
        case .eventReminders(let isHappeningsReminderOn):
            return isHappeningsReminderOn
        case .announcements(let isAnnouncementsReminderOn):
            return isAnnouncementsReminderOn
        default:
            return false
        }
    }
    
    /// Indicates if the menu item is log out.
    var isLogOut: Bool {
        switch self {
        case .logout:
            return true
        default:
            return false
        }
    }
    
}
