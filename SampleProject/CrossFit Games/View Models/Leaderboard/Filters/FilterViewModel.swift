//
//  FilterViewModel.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/21/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// View model for filter view controller.
protocol FilterViewModel {

    /// Title of the initial screen.
    var title: String { get }

    /// Options to select from.
    var selectionOptions: [FilterViewModelSelectionOption] { get }

    /// Indicates whether content should be grouped alphabetically.
    var shouldGroupContentAlphabetically: Bool { get }

    /// Resets filters for current year/competition.
    func reset()

}
