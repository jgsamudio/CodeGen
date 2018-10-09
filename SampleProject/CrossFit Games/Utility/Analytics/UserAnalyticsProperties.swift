//
//  UserAnalyticsProperties.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/2/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Analytics properties for logging an app user's information.
final class UserAnalyticsProperties: RawRepresentable {
    typealias RawValue = [String: Any]

    // MARK: - Public Properties
    
    private(set) var rawValue: [String: Any]

    // MARK: - Initialization
    
    init(personalizedLeaderboard: PersonalizedLeaderboard?) {
        rawValue = [:]
        if let country = personalizedLeaderboard?.countryName {
            rawValue[AnalyticsKey.Property.country.rawValue] = country
        } else {
            rawValue[AnalyticsKey.Property.country.rawValue] = NSNull()
        }
        if let language = Locale.preferredLanguages.first {
            rawValue[AnalyticsKey.Property.language.rawValue] = language
        } else {
            rawValue[AnalyticsKey.Property.language.rawValue] = NSNull()
        }
        if let firstName = personalizedLeaderboard?.firstName {
            rawValue[AnalyticsKey.Property.firstName.rawValue] = firstName
        } else {
            rawValue[AnalyticsKey.Property.firstName.rawValue] = NSNull()
        }
        let group = DispatchGroup()
        group.enter()
        PushNotifications.shared.isPushEnabled { (result) in
            self.rawValue[AnalyticsKey.Property.pushEnabled.rawValue] = result ? "true" : "false"
            group.leave()
        }
        _ = group.wait(timeout: .now() + 0.1)
        if let mostRecentOpen = personalizedLeaderboard?.mostRecentOpenCompetition?.year {
            rawValue[AnalyticsKey.Property.openRegistered.rawValue] = "Open \(mostRecentOpen)"
        } else {
            rawValue[AnalyticsKey.Property.openRegistered.rawValue] = NSNull()
        }
        if let division = personalizedLeaderboard?.mostRecentOpenCompetition?.divisionName
            ?? personalizedLeaderboard?.divisionName {
            rawValue[AnalyticsKey.Property.division.rawValue] = division
        } else {
            rawValue[AnalyticsKey.Property.division.rawValue] = NSNull()
        }
        if let occupation = personalizedLeaderboard?.professionName {
            rawValue[AnalyticsKey.Property.occupation.rawValue] = occupation
        } else {
            rawValue[AnalyticsKey.Property.occupation.rawValue] = NSNull()
        }
        if let userId = personalizedLeaderboard?.competitorId {
            rawValue[AnalyticsKey.Property.userId.rawValue] = "\(userId)"
        } else {
            rawValue[AnalyticsKey.Property.userId.rawValue] = NSNull()
        }
    }

    init?(rawValue: [String: Any]) {
        self.rawValue = rawValue
    }

}
