//
//  MainTabBarViewDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol MainTabBarViewDelegate: class {

    /// Indicates user tapped the contact us menu item.
    ///
    /// - Parameter url: URL to open.
    func contactUsSelected(email: String)
    
    /// Called when the settings menu item is selected.
    func settingsSelected()
    
    /// Called when the privacy policy menu item is selected.
    ///
    /// - Parameter url: URL to open.
    func privacyPolicySelected(url: URL)

    /// Called when the `terms and conditions` menu item is selected.
    ///
    /// - Parameter url: URL to open.
    func termsAndConditionsSelected(url: URL)
    
    /// Called when house rules is selected
    func houseRulesSelected()
    
}
