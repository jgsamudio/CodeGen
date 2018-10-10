//
//  UserDefaultExtensions.swift
//  TheWing
//
//  Created by Paul Jones on 8/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Keys for accessing user defaults
///
/// - completedOnboarding: the completed onboarding flag
/// - pushPermissionLastAskedDate: the date that we last asked for push permission
/// - announcementsReminder: Push notification for annoucements
/// - happeningsReminder: Push notification for happenings
/// - eventsFilters: Event filters
/// - communityFilters: Community filters
/// - attendeesFilters: Attendees filters
enum UserDefaultsKeys: String, UserDefaultsKeyConvertible {
    case completedOnboarding = "COMPLETED_ONBOARDING"
    case pushPermissionLastAskedDate = "LAST_ASKED_PUSH_NOTIFICATION_DATE"
    case announcementsReminder = "SettingsAnnouncementsReminder"
    case happeningsReminder = "SettingsHappeningsReminder"
    case eventsFilters = "EventsFilters"
    case communityFilters = "CommunityFilters"
    
    // MARK: - Public Properties
    
    var userDefaultsKey: String {
        return rawValue
    }

}

extension UserDefaults {
    
    /// This is a temporary solution while backend works out how they want to support this feature.
    var completedOnboarding: Bool {
        get {
            return bool(forKey: UserDefaultsKeys.completedOnboarding)
        } set {
            set(newValue, forKey: UserDefaultsKeys.completedOnboarding)
        }
    }
    
    /// The last time we asked for push permission, you probably just want to set this and use
    /// `canAttemptToAskForPushPermission` for logic.
    var pushPermissionLastAskedDate: Date? {
        get {
            return object(forKey: UserDefaultsKeys.pushPermissionLastAskedDate)
        } set {
            set(newValue, forKey: UserDefaultsKeys.pushPermissionLastAskedDate)
        }
    }
    
    /// Has it been a sufficient time since last attempt to ask for push permission to ask again?
    var canAttemptToAskForPushPermission: Bool {
        if let pushPermissionLastAskedDate = pushPermissionLastAskedDate {
            return Date.daysSince(date: pushPermissionLastAskedDate) >= 7
        } else {
            return true 
        }
    }
    
    /// Should push annoucments notifications
    var pushAnnoucements: Bool {
        get {
            return bool(forKey: UserDefaultsKeys.announcementsReminder)
        } set {
            set(newValue, forKey: UserDefaultsKeys.announcementsReminder)
        }
    }
    
    /// Should push happenings notifications
    var pushHappenings: Bool {
        get {
            return bool(forKey: UserDefaultsKeys.happeningsReminder)
        } set {
            set(newValue, forKey: UserDefaultsKeys.happeningsReminder)
        }
    }
    
    var eventFilters: SectionedFilterParameters? {
        get {
            return decode(forKey: UserDefaultsKeys.eventsFilters)
        } set {
            encode(newValue, forKey: UserDefaultsKeys.eventsFilters)
        }
    }
    
    var communityFilters: SectionedFilterParameters? {
        get {
            return decode(forKey: UserDefaultsKeys.communityFilters)
        } set {
            encode(newValue, forKey: UserDefaultsKeys.communityFilters)
        }
    }

}

// MARK: - Pass a user defaults convertible instead of a string to get a user default.
extension UserDefaults {
    
    // MARK: - Public Functions
    
    func removeAllObjects() {
        for key in dictionaryRepresentation().keys {
            removeObject(forKey: key)
        }
    }
    
    func removeObjects(_ objects: [UserDefaultsKeyConvertible]) {
        for keyConvertible in objects {
            removeObject(forKey: keyConvertible.userDefaultsKey)
        }
    }
    
    func decode<T: Codable>(forKey defaultName: UserDefaultsKeyConvertible) -> T? {
        if let data = object(forKey: defaultName.userDefaultsKey) as? Data {
            return try? JSONDecoder().decode(T.self, from: data)
        } else {
            return nil
        }
    }
    
    func encode<T: Codable>(_ value: T?, forKey defaultName: UserDefaultsKeyConvertible) {
        if let encodedValue = try? JSONEncoder().encode(value) {
            set(encodedValue, forKey: defaultName.userDefaultsKey)
        }
    }
    
    func object<T>(forKey defaultName: UserDefaultsKeyConvertible) -> T? {
        return object(forKey: defaultName.userDefaultsKey) as? T
    }
    
    func object(forKey defaultName: UserDefaultsKeyConvertible) -> Any? {
        return object(forKey: defaultName.userDefaultsKey)
    }
    
    func set(_ value: Any?, forKey defaultName: UserDefaultsKeyConvertible) {
        set(value, forKey: defaultName.userDefaultsKey)
    }
    
    func removeObject(forKey defaultName: UserDefaultsKeyConvertible) {
        removeObject(forKey: defaultName.userDefaultsKey)
    }
    
    func string(forKey defaultName: UserDefaultsKeyConvertible) -> String? {
        return string(forKey: defaultName.userDefaultsKey)
    }
    
    func array(forKey defaultName: UserDefaultsKeyConvertible) -> [Any]? {
        return array(forKey: defaultName.userDefaultsKey)
    }
    
    func dictionary(forKey defaultName: UserDefaultsKeyConvertible) -> [String: Any]? {
        return dictionary(forKey: defaultName.userDefaultsKey)
    }
    
    func data(forKey defaultName: UserDefaultsKeyConvertible) -> Data? {
        return data(forKey: defaultName.userDefaultsKey)
    }
    
    func stringArray(forKey defaultName: UserDefaultsKeyConvertible) -> [String]? {
        return stringArray(forKey: defaultName.userDefaultsKey)
    }
    
    func integer(forKey defaultName: UserDefaultsKeyConvertible) -> Int {
        return integer(forKey: defaultName.userDefaultsKey)
    }
    
    func float(forKey defaultName: UserDefaultsKeyConvertible) -> Float {
        return float(forKey: defaultName.userDefaultsKey)
    }
    
    func double(forKey defaultName: UserDefaultsKeyConvertible) -> Double {
        return double(forKey: defaultName.userDefaultsKey)
    }
    
    func bool(forKey defaultName: UserDefaultsKeyConvertible) -> Bool {
        return bool(forKey: defaultName.userDefaultsKey)
    }
    
    func url(forKey defaultName: UserDefaultsKeyConvertible) -> URL? {
        return url(forKey: defaultName.userDefaultsKey)
    }
    
    func set(_ value: Int, forKey defaultName: UserDefaultsKeyConvertible) {
        set(value, forKey: defaultName.userDefaultsKey)
    }
    
    func set(_ value: Float, forKey defaultName: UserDefaultsKeyConvertible) {
        set(value, forKey: defaultName.userDefaultsKey)
    }
    
    func set(_ value: Double, forKey defaultName: UserDefaultsKeyConvertible) {
        set(value, forKey: defaultName.userDefaultsKey)
    }
    
    func set(_ value: Bool, forKey defaultName: UserDefaultsKeyConvertible) {
        set(value, forKey: defaultName.userDefaultsKey)
    }
    
    func set(_ url: URL?, forKey defaultName: UserDefaultsKeyConvertible) {
        set(url, forKey: defaultName.userDefaultsKey)
    }

}
