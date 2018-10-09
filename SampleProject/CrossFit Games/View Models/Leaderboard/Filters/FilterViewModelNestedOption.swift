//
//  FilterViewModelNestedOption.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/22/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Nested filter selection option.
protocol FilterViewModelNestedOption: FilterViewModelSelectionOption {

    /// Title of the selected, nested option.
    var selectedOption: () -> String? { get }

    /// Nested filter options.
    var nestedOptions: [FilterViewModelSelectionOption] { get }

    /// Inidcates whether the provided selection options should be grouped alphabetically with a
    /// bar on the right side to swipe through the table and jump to specific letters.
    var shouldGroupContentAlphabetically: Bool { get }

}

// MARK: - Default behavior
extension FilterViewModelNestedOption {

    var isSelected: () -> Bool {
        return { return false }
    }

}
