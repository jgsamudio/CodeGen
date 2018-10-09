//
//  InstabugIntegration.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/6/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation
#if !RELEASE
    import Instabug
#endif
import Keys

/// Interface for interaction with Instabug.
struct InstabugIntegration {

    /// Shared instance to be used for interacting with instabug.
    static let shared = InstabugIntegration()

    private init() {}

    /// Sets up instabug to use the right app ID for bug logging.
    func prepare() {
        #if !RELEASE
        Instabug.setCrashReportingEnabled(false)
        Instabug.start(withToken: CrossfitgamesKeys().instabug(), invocationEvent: IBGInvocationEvent.none)
        #endif
    }

    /// Invokes instabug, showing the menu to log bugs, take screenshots, etc.
    func invoke() {
        #if !RELEASE
        Instabug.invoke()
        #endif
    }

}
