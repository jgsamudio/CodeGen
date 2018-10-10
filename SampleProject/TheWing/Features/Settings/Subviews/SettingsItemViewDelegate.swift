//
//  SettingsItemViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 8/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol SettingsItemViewDelegate: class {
    
    /// Called to turn on/off a noficiation corresponding to the settings view's item.
    ///
    /// - Parameters:
    ///   - switchType: Settings switch type. ( e.g. events, announcements )
    ///   - isOn: The desired switch state to toggle to.
    func toggleNotifications(switchType: SettingsSwitchType?, isOn: Bool)

}
