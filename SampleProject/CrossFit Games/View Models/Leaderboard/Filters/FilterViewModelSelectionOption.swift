//
//  FilterViewModelSelectionOption.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/22/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Single tap selection option for filters.
protocol FilterViewModelSelectionOption {

    /// Title of the selection option.
    var title: String { get }

    /// Filter selection service used to select filters.
    var isSelected: () -> Bool { get }

    /// Associated filter name.
    var filterName: String { get }

    /// Nested filter selection option that contains `self`.
    var parent: FilterViewModelNestedOption? { get set }

    /// Performs any actions upon selecting `self` as an option.
    func didSelect()

}
