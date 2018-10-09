//
//  AccountCellOption.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/28/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Cell Options for Account
enum AccountCellOption {

    /// Help
    case help

    /// Contact Us
    case contactUs

    /// Rule Book
    case ruleBook

    /// Drug Policy
    case drugPolicy

    /// Logout
    case logout

    /// Login
    case login

    /// Frequently asked questions
    case faq

    // MARK: - Public Functions
    
    /// Localize based on case
    ///
    /// - Returns: String to display
    func localize() -> String {
    
    // MARK: - Public Properties
    
        let localization = AccountLocalization()
        switch self {    
        case .help:
            return localization.help
        case .contactUs:
            return localization.contactUs
        case .ruleBook:
            return localization.ruleBook
        case .drugPolicy:
            return localization.drugPolicy
        case .logout:
            return localization.logout
        case .login:
            return localization.login
        case .faq:
            return localization.faq
        }
    }

    /// Returns url based on case if possible
    ///
    /// - Returns: URL for case
    func url() -> URL? {
        switch self {
        case .help:
            return URL(string: "https://games-support.crossfit.com/")
        case .contactUs:
            return nil
        case .ruleBook:
            return URL(string: "https://games.crossfit.com/rules/games/2018")
        case .drugPolicy:
            return URL(string: "https://games.crossfit.com/drug-policy")
        case .faq:
            return URL(string: "https://games-support.crossfit.com/collection/306-app")
        case .logout, .login:
            return nil
        }
    }

}
