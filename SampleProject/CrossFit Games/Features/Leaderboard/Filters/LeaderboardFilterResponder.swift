//
//  LeaderboardFilterResponder.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/18/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Data source
protocol LeaderboardFilterResponder: class {

    /// Called when the leaderboard filter view generated a new leaderboard result view model with adjusted filters.
    ///
    /// - Parameters
    ///   - viewModel: View model to feed to a leaderboard result view controller.
    ///   - athleteId: ID of the athlete to scroll to (optional).
    func viewShouldReload(with viewModel: LeaderboardResultViewModel,
                          scrollingToAthlete athleteId: String?,
                          onPage page: Int?,
                          showingLoadingView: Bool)

}
