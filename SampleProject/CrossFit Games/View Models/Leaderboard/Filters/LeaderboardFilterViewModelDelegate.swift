//
//  LeaderboardFilterViewModelDelegate.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/11/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Protocol for delegates of `LeaderboardFilterViewModel`.
protocol LeaderboardFilterViewModelDelegate: class {

    /// Called when the given filter view model received new filters to display.
    ///
    /// - Parameter viewModel: View model that needs a reload.
    func filterViewModelRequiresReload(_ viewModel: LeaderboardFilterContent)

    /// Called when the given view model created a new view model to be used by the leaderboard result screen.
    ///
    /// - Parameters:
    ///   - viewModel: View model that was used to create the result view model.
    ///   - resultViewModel: Result view model that was created.
    ///   - athleteId: Athlete ID that was searched for.
    func filterViewModel(_ viewModel: LeaderboardFilterContent,
                         createdResultViewModel resultViewModel: LeaderboardResultViewModel,
                         searchingAthlete athleteId: String?)

}
