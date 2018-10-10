//
//  AnalyticsProvider.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/9/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Analytics provider.
protocol AnalyticsProvider {
    
    /// Starts the analytics provider.
    func start()
    
    /// Ties a user to actions and records traits about them.
    ///
    /// - Parameters:
    ///   - userId: User id.
    ///   - userTraits: User traits.
    func identify(userId: String,
                  userTraits: [String: Any]?)
    
    /// Record the actions a user peforms.
    ///
    /// - Parameters:
    ///   - event: Name of the event.
    ///   - properties: Properties associated with event.
    ///   - options: Options.
    func track(event: String,
               properties: [String: Any]?,
               options: [String: Any]?)
    
    /// Create a record of the user seeing a screen.
    ///
    /// - Parameters:
    ///   - screenTitle: Screen title.
    ///   - properties: Properties.
    ///   - options: Options.
    func screen(screenTitle: String,
                properties: [String: Any]?,
                options: [String: Any]?)
    
    /// Clear internal stores for current user.
    func reset()
    
}
