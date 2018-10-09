//
//  FirebaseAnalyticsModule.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 12/11/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import FirebaseAnalytics
import Simcoe

/// Analytics module for use within Simcoe.
struct FirebaseAnalyticsModule {

    let name = "Firebase"

}

// MARK: - UserAttributeTracking
extension FirebaseAnalyticsModule: UserAttributeTracking {

    func setUserAttribute(_ key: String, value: Any) -> TrackingResult {
        if key == AnalyticsKey.Property.userId.rawValue {
            Analytics.setUserID(value as? String)
        } else {
            Analytics.setUserProperty(value as? String, forName: key)
        }
        return .success
    }

    func setUserAttributes(_ attributes: Properties) -> TrackingResult {
        var attributes = attributes
        let removedValue = attributes.removeValue(forKey: AnalyticsKey.Property.userId.rawValue)
        Analytics.setUserID(removedValue as? String)

        attributes.forEach { info in
            Analytics.setUserProperty(info.value as? String, forName: info.key)
        }
        return .success
    }

}

// MARK: - EventTracking
extension FirebaseAnalyticsModule: EventTracking {

    func track(event: String, withAdditionalProperties properties: Properties?) -> TrackingResult {
        for property in properties ?? [:] {
            guard property.value is IntegerLiteralType || property.value is StringLiteralType else {
                return .error(message: "Neither string nor number value")
            }
        }
        if event == AnalyticsKey.Event.trackScreen.rawValue {
            if let properties = properties,
                let screen = properties[AnalyticsKey.Property.screen.rawValue] as? String,
                let className = properties[AnalyticsKey.Property.className.rawValue] as? String {
                Analytics.setScreenName(screen, screenClass: className)
            }
        } else {
            Analytics.logEvent(event, parameters: properties)
        }

        return .success
    }

    func start() {
        FirebaseInstance.setupIfNeeded()
    }

    func flush() { /* Nop */ }

}
