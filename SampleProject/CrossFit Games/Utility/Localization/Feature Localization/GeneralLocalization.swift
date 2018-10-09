//
//  GeneralLocalization.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/4/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Localization constants for general app functionality.
struct GeneralLocalization {

    // MARK: - Public Properties
    
    /// Error title for a banner.
    let bannerErrorTitle = "GENERAL_BANNER_ERROR".localized

    /// Success title for a banner.
    let bannerSuccessTitle = "GENERAL_BANNER_SUCCESS".localized

    let sort = "GENERAL_SORT".localized

    let filter = "GENERAL_FILTER".localized

    let filters = "GENERAL_FILTERS".localized

    let pushTitle = "GENERAL_PUSH_TITLE".localized

    let pushBody = "GENERAL_PUSH_BODY".localized

    let pushAccept = "GENERAL_PUSH_ACCEPT".localized

    let pushDeny = "GENERAL_PUSH_DENY".localized

    let forceUpdate = "GENERAL_APP_FORCE_UPDATE".localized

    let errorRefresh = "GENERAL_APP_ERROR_REFRESH".localized

    let errorTitle = "GENERAL_APP_ERROR_TITLE".localized

    let errorMessage = "GENERAL_APP_ERROR_MESSAGE".localized

    // MARK: - Public Functions
    
    /// Localized string for the word in.
    ///
    /// - Parameter suffix: Suffix to apply after the word in
    /// - Returns: Formatted, localized in string.
    func inString(suffix: String) -> String {
        return String.localizedStringWithFormat("GENERAL_IN".localized, suffix)
    }

}
