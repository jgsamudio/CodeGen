//
//  Simcoe+CrossFit.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/2/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation
import Simcoe

extension Simcoe {

    /// Tracks an analytics action or event.
    ///
    /// - Parameters:
    ///   - event: The event that occurred.
    ///   - properties: The optional additional properties.
    ///   - screen: The screen on which the event was tracked (if needed).
    class func track(event: AnalyticsKey.Event,
                     withAdditionalProperties additionalProperties: [AnalyticsKey.Property: Any],
                     on screen: AnalyticsKey.Screen? = nil) {
        var dict = [String: Any]()
        for key in additionalProperties.keys {
            dict[key.rawValue] = additionalProperties[key]
        }
        if let screen = screen {
            dict[AnalyticsKey.Property.screen.rawValue] = screen.rawValue
        }
        Simcoe.track(event: event.rawValue, withAdditionalProperties: dict)
    }

    /// Sets the User Attribute.
    ///
    /// - Parameters:
    ///   - key: The attribute key to log.
    ///   - value: The attribute value to log.
    class func setUserAttribute(_ key: AnalyticsKey.Property, value: Any) {
        Simcoe.setUserAttribute(key.rawValue, value: value)
    }

}
