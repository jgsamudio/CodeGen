//
//  ProfileTagType.swift
//  TheWing
//
//  Created by Luna An on 3/29/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Tag data for the type.
typealias TagData = (isSelectable: Bool, isRemovable: Bool)

enum ProfileTagType {
    case offers(TagData)
    case interests(TagData)
    case asks(TagData)

    // MARK: - Public Properties
    
    /// Returns the title for each type.
    var title: String {
        switch self {
        case .offers:
            return "OFFERS".localized(comment: "Offers section title")
        case .asks:
            return "ASKS".localized(comment: "Asks section title")
        case .interests:
            return "INTERESTS".localized(comment: "Interests section title")
        }
    }
    
    /// Returns the helper text for each type.
    var helperText: String {
        switch self {
        case .offers:
            return "SEARCH_OFFERS".localized(comment: "Offers search bar helpder text")
        case .asks:
            return "SEARCH_ASKS".localized(comment: "Looking For search bar helper text")
        case .interests:
            return "SEARCH_INTERESTS".localized(comment: "Interested In search bar helpder text")
        }
    }
    
    /// Search param for tag type.
    var searchParam: String {
        switch self {
        case .offers:
            return "offers"
        case .asks:
            return "asks"
        case .interests:
            return "interests"
        }
    }

}

// MARK: - TagViewDataSource
extension ProfileTagType: TagViewDataSource {

    /// Flag to determine if the tag is removable.
    var isRemovable: Bool {
        switch self {
        case .offers(let data):
            return data.isRemovable
        case .asks(let data):
            return data.isRemovable
        case .interests(let data):
            return data.isRemovable
        }
    }
    
    /// Flag to determine if the tag is selectable.
    var isSelectable: Bool {
        switch self {
        case .offers(let data):
            return data.isSelectable
        case .asks(let data):
            return data.isSelectable
        case .interests(let data):
            return data.isSelectable
        }
    }
    
    /// Flag to determine if the tag is selected.
    var selected: Bool {
        return false
    }

    // MARK: - Public Functions
    
    /// Returns cell background color given theme.
    ///
    /// - Parameter theme: Theme.
    /// - Returns: UIColor.
    func cellBackgroundColor(theme: Theme) -> UIColor {
        switch self {
        case .offers:
            return theme.colorTheme.invertPrimary
        case .asks:
            return theme.colorTheme.invertSecondary
        case .interests:
            return theme.colorTheme.tertiary.withAlphaComponent(0.15)
        }
    }

}
