//
//  EditOccupationType.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/3/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Occupation view controller type.
///
/// - editOccupation: Edits the selected occupation.
/// - addOccupation: Adds a new occupation.
enum EditOccupationType {
    case editOccupation
    case addOccupation

    // MARK: - Public Properties
    
    /// Title for edit occupation view controller.
    var title: String {
        switch self {
        case .editOccupation:
            return "EDIT_OCCUPATION_TITLE".localized(comment: "Edit occupation title")
        case .addOccupation:
            return "ADD_OCCUPATION_TITLE".localized(comment: "Add occupation title")
        }
    }

}
