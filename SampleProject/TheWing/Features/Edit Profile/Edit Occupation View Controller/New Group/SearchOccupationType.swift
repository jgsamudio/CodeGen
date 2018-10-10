//
//  SearchOccupationType.swift
//  TheWing
//
//  Created by Luna An on 4/9/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Enumerates search occupation types.
///
/// - positions: Position type.
/// - companies: Company type.
enum SearchOccupationType: String {
    case positions
    case companies
    
    // MARK: - Public Properties
    
    /// Returns the helper text for each type.
    var helperText: String {
        switch self {
        case .positions:
            return "SEARCH_POSITIONS".localized(comment: "Positions search bar helpder text")
        case .companies:
            return "SEARCH_COMPANIES".localized(comment: "Companies search bar helper text")
        }
    }
    
}
