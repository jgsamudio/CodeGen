//
//  LoginAnalyticsDelegate.swift
//  TheWing
//
//  Created by Luna An on 8/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol LoginAnalyticsDelegate: class {
    
    /// Called to identify user traits.
    func identifyUserTraits()
    
    /// Called to track login event.
    func trackLoginEvent()

    /// Called to capture screen information.
    func captureScreenInformation()
    
}
