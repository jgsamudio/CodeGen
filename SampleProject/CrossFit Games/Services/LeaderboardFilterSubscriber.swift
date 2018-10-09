//
//  LeaderboardFilterSubscriber.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/28/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Protocol for classes that can subscribe for filter selection changes.
protocol LeaderboardFilterSubscriber: class {

    /// Called whenever filters got changed.
    ///
    /// - Parameter selectionService: Filter selection service that was used to change filters.
    func filtersChanged(on selectionService: LeaderboardFilterSelectionService)

}
