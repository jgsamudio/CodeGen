//
//  SnackBarLocalization.swift
//  TheWing
//
//  Created by Paul Jones on 9/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Snack bar localization container.
///
/// - calenderPermission: Calender permission snackbar localization
/// - bookmarkAdded: Bookmarked added snackbar localization
/// - connectivityError: Connectivity error snackbar localization
enum SnackBarLocalization: String {
    case calenderPermission = "SNACK_BAR_CALENDAR_PERMISSION"
    case bookmarkAdded = "SNACK_BAR_BOOKMARK_ADDED"
    case connectivityError = "CONNECTIVITY_ERROR"
}

// MARK: - Localizable
extension SnackBarLocalization: Localizable {
    
    // MARK: - Public Properties
    
    var localized: String {
        return rawValue.localized(comment: "Snack bar localization")
    }
    
}
