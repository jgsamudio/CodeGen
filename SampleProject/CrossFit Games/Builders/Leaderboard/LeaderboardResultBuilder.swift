//
//  LeaderboardResultBuilder.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/9/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

struct LeaderboardResultBuilder: Builder {

    // MARK: - Public Properties
    
    let layout: LeaderboardResultLayout

    // MARK: - Public Functions
    
    func build() -> UIViewController {
        let viewController: LeaderboardResultViewController = UIStoryboard(name: "Leaderboard", bundle: nil).instantiateViewController()
        injectDependencies(for: viewController)
        return viewController
    }

    /// Convenience methods to inject dependencies if a view controller was created through storyboard segues or other.
    ///
    /// - Parameter viewController: View controller whose dependencies need to be injected.
    func injectDependencies(for viewController: LeaderboardResultViewController) {
        let filterViewModel = LeaderboardFilterContent()
        viewController.filterViewModel = filterViewModel
        viewController.layout = layout
        let leaderBoardResultViewModel = LeaderboardResultViewModel(customLeaderboard: nil)
        viewController.viewModel = leaderBoardResultViewModel
    }

}
