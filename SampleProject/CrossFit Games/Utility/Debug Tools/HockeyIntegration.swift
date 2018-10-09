//
//  HockeyIntegration.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/6/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation
import Keys

#if ALPHA || BETA
    import HockeySDK
#endif

/// Integration of HockeyApp SDK.
struct HockeyIntegration {

    /// Sets up the HockeyApp SDK. This function does nothing if run on either debug or production environment.
    static func setup() {
        #if ALPHA || BETA
        guard let hockeyAppID = CrossfitgamesKeys().hockeyAppID() else {
            return
        }

        BITHockeyManager.shared().isCrashManagerDisabled = true
        BITHockeyManager.shared().configure(withIdentifier: hockeyAppID)
        BITHockeyManager.shared().start()
        #endif
    }

    /// Checks the app version. This function does nothing if run on either debug or production environment.
    static func checkVersion() {
        #if ALPHA || BETA
        BITHockeyManager.shared().authenticator.authenticateInstallation()
        #endif
    }

}
