//
//  CrashlyticsIntegration.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/9/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation
import Crashlytics
import Fabric

/// Struct for interaction with Crashlytics SDK.
struct CrashlyticsIntegration {

    // MARK: - Public Properties
    
    /// Shared instance.
    static let shared = CrashlyticsIntegration()

    // MARK: - Initialization
    
    private init() {}

    // MARK: - Public Functions
    
    /// Sets up Crashlytics for crash logging.
    func setup() {
        Fabric.with([Crashlytics.self])
    }

    /// Sets the user ID for crash logging.
    func setUserId(_ userID: String?) {
        Crashlytics().setUserIdentifier(userID)
    }

    /// Logs the given Crashlytics event.
    func log(event: CrashlyticsCustomEvent) {
        Crashlytics().recordError(event.error)
    }

    #if DEBUG || ALPHA || BETA
    /// Crashes the app for debug purposes.
    func crash() {
        Crashlytics.sharedInstance().throwException()
    }
    #endif

}
