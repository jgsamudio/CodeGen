//
//  LocationTracking.swift
//  Simcoe
//
//  Created by Christopher Jones on 2/16/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import CoreLocation

/// Defines methods for tracking a user's location data.
public protocol LocationTracking: AnalyticsTracking {

    /// Tracks location.
    ///
    /// - Parameters:
    ///   - location: The location to track.
    ///   - properties: The optional additional properties.
    /// - Returns: A tracking result.
    func track(location: CLLocation, withAdditionalProperties properties: Properties?) -> TrackingResult

}
