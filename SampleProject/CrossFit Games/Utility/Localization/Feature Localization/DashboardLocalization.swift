//
//  DashboardLocalization.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/10/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

struct DashboardLocalization {

    // MARK: - Public Properties
    
    /// Account text
    let accountYour = "DASHBOARD_ACCOUNT_YOUR".localized

    let accountWelcome = "DASHBOARD_ACCOUNT_WELCOME".localized

    let accountLogin = "DASHBOARD_ACCOUNT_LOGIN".localized

    let worldwide = "DASHBOARD_WORLDWIDE".localized

    let tap = "DASHBOARD_COACHMARK_TAP".localized

    // MARK: - Public Functions
    
    /// Appends "Rank" to a given string (like: Worldwide + Rank = "Worldwide Rank")
    ///
    /// - Parameter string: String that needs Rank appended to it.
    /// - Returns: Localized string with "Rank" appended.
    func appendRank(to string: String) -> String {
        return String.localizedStringWithFormat("DASHBOARD_APPEND_RANK".localized, string)
    }

    /// Appends the url to the localized string
    ///
    /// - Parameter url: url string
    /// - Returns: Localized formatted app share test
    func appShareURL(url: String) -> String {
        return String.localizedStringWithFormat("DASHBOARD_APP_SHARE".localized, url)
    }

    /// Appends the athlete division
    ///
    /// - Parameter division: Division to be appended
    /// - Returns: Localized division string
    func faaDivision(division: String) -> String {
         return String.localizedStringWithFormat("DASHBOARD_FAA_DIVISION".localized, division)
    }

}
