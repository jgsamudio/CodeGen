//
//  UserAttributesData.swift
//  TheWing
//
//  Created by Luna An on 8/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class UserAttributesData {
    
    // MARK: - Public Properties
    
    /// Singleton user attributes analytics data instance.
    static var shared = UserAttributesData()
    
    /// App platform.
    var platform = AnalyticsConstants.iOS
    
    /// User traits.
    var userTraits: [String: Any] {
        return [AnalyticsConstants.platformKey: platform,
                AnalyticsConstants.announcementsReminderKey: UserDefaults.standard.pushAnnoucements,
                AnalyticsConstants.happeningsReminderKey: UserDefaults.standard.pushHappenings]
    }

}
