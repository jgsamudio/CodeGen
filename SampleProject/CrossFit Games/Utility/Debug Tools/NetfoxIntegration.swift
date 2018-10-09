//
//  NetfoxIntegration.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 12/4/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation
#if !RELEASE
    import netfox
#endif

/// Manages integration of netfox pod into ios application. Allows any tester to view API logs directly within app
struct NetfoxIntegration {

    // MARK: - Public Properties
    
    /// Shared instance to be used for interacting with instabug.
    static let shared = NetfoxIntegration()

    // MARK: - Public Functions
    
    /// Sets up pod and ensures gestures are controlled by yoshi only
    func setup() {
        #if !RELEASE
            NFX.sharedInstance().start()
            NFX.sharedInstance().setGesture(.custom)
        #endif
    }

    /// Shows netfox screen to usert
    func show() {
        #if !RELEASE
            NFX.sharedInstance().show()
        #endif
    }

}
