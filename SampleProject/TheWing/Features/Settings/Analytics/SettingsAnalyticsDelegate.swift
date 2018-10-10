//
//  SettingsAnalyticsDelegate.swift
//  TheWing
//
//  Created by Luna An on 8/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol SettingsAnalyticsDelegate: class {
    
    /// Identifies user traits when notification state changes.
    ///
    /// - Parameter switchType: Switch type to use to determine which notification to turn on and off.
    func identifyUserTraits(from switchType: SettingsSwitchType)

}
