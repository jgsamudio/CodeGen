//
//  MenuItemType.swift
//  TheWing
//
//  Created by Jonathan Samudio on 8/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// <Description of the class>
///
/// **Subspec: Folder/Filename**
///
/// ```
/// Code Snippet
/// ```
///
/// <Real world example of how someone would use this class with code snippet>
enum MenuItemType {
    case settings
    case privacy
    case termsConditions
    case contactUs
    
    // MARK: - Public Properties
    
    /// Order of the menu items to display.
    static var menuListItems: [MenuItemType] {
        return [.settings, .privacy, .termsConditions, .contactUs]
    }
    
    /// Title of the menu item.
    var title: String {
        switch self {
        case .settings:
            return "SETTINGS".localized(comment: "Settings")
        case .privacy:
            return "PRIVACY_POLICY".localized(comment: "Privacy Policy")
        case .termsConditions:
            return "TERMS_AND_CONDITIONS_TITLE".localized(comment: "Terms and conditions")
        case .contactUs:
            return "CONTACT_US".localized(comment: "Contact Us")
        }
    }

}
