//
//  FollowAnAthleteDelegate.swift
//  CrossFit Games
//
//  Created by Malinka S on 2/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// A delegate where the conformed instances will be notified if any event takes place
/// regarding following an athlete
protocol FollowAnAthleteDelegate: class {

    /// Is invoked when tap event is triggered
    ///
    /// - Parameters:
    ///   - isAdded: Specifies if an athlete was added/removed as a follower
    ///   - indexPath: Indexpath of the relevant cell
    func didTap(isAdded: Bool, indexPath: IndexPath, athleteId: String?)

    /// Invoked when the modal view is dismissed
    func modalDismissed()
}
