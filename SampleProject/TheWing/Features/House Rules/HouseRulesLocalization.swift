//
//  HouseRulesLocalization.swift
//  TheWing
//
//  Created by Paul Jones on 9/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// House rules localization
///
/// - title: The title of the House Rules section
enum HouseRulesLocalization {
    case title
}

// MARK: - Localizable
extension HouseRulesLocalization: Localizable {
    
    // MARK: - Public Properties
    
    var localized: String {
        return "HOUSE_RULES_TITLE".localized(comment: "House Rules")
    }
    
}
