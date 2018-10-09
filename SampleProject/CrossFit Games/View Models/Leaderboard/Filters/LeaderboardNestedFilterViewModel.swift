//
//  LeaderboardNestedFilterViewModel.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/28/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// View model for a filter screen that is pushed upon selecting a nested option.
struct LeaderboardNestedFilterViewModel: FilterViewModel {

    // MARK: - Public Properties
    
    let title: String

    let selectionOptions: [FilterViewModelSelectionOption]

    let shouldGroupContentAlphabetically: Bool

    // MARK: - Initialization
    
    /// Creates a view model with the given nested option.
    ///
    /// - Parameter nestedOption: Nested option the user selected to push a new filter view controller.
    init(nestedOption: FilterViewModelNestedOption) {
        title = nestedOption.title
        // TODO: Add Lift Off back into filter options whenever following ticket is played:
        // https://www.pivotaltracker.com/story/show/153519261
        // Current Reason Removing LiftOff from filter: https://www.pivotaltracker.com/story/show/153421030
        selectionOptions = nestedOption.nestedOptions.filter { $0 .title != "Liftoff" && $0 .title != "Team Series" }
        shouldGroupContentAlphabetically = nestedOption.shouldGroupContentAlphabetically
    }

    // MARK: - Public Functions
    
    func reset() {
        return
    }

}
