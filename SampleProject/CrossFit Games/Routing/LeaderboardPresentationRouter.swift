//
//  LeaderboardPresentationRouter.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/16/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Router to present a leaderboard from the dashboard screens.
enum LeaderboardPresentationRouter {

    /// Tab bar controller for navigating around.
    case switchingTabsIn(tabBarController: UITabBarController?)

    case pushingIn(navigationController: UINavigationController?, title: String?, subtitle: String?, isAffiliateLeaderboard: Bool)

    /// Presents a custom leaderboard on the leaderboard screen, searching for the provided athlete ID.
    ///
    /// - Parameters:
    ///   - leaderboard: Leaderboard to jump to.
    ///   - athleteId: Athlete ID to search for.
    ///   - completionHandler: Triggered whenever present is completed
    func present(leaderboard: CustomLeaderboard, searchingAthlete athleteId: String?, onPage page: Int?, completion: (() -> Void)? = nil) {
        switch self {
        case .switchingTabsIn(tabBarController: let tabBarController):
            switchTabs(in: tabBarController, presenting: leaderboard, searching: athleteId, onPage: page, completion: completion)
        case .pushingIn(navigationController: let navigationController,
                        title: let title,
                        subtitle: let subtitle,
                        isAffiliateLeaderboard: let isAffiliateLeaderboard):
            push(in: navigationController,
                 presenting: leaderboard,
                 title: title,
                 subtitle: subtitle,
                 isAffiliateLeaderboard: isAffiliateLeaderboard,
                 searching: athleteId,
                 onPage: page,
                 completion: completion)
        }
    }

    private func switchTabs(in tabBarController: UITabBarController?,
                            presenting leaderboard: CustomLeaderboard,
                            searching athleteId: String?,
                            onPage page: Int?,
                            completion: (() -> Void)? = nil) {
        /// Get leaderboard result view controller.
        guard let leaderboardResultViewController = AppLayout.global.leaderboardResultViewController else {
            return
        }
        guard let navController = leaderboardResultViewController.navigationController else {
            return
        }
        leaderboardResultViewController.loadViewIfNeeded()

        /// Get index of the leaderboard nav controller within the tab bar.
        guard let resultControllerIndex = tabBarController?.viewControllers?
            .index(of: navController) else {
                return
        }

        let viewModelToLoad = LeaderboardResultViewModel(customLeaderboard: leaderboard)
        let newFilterViewModel = LeaderboardFilterContent(leaderboard: leaderboard)
        viewModelToLoad.retrieveLeaderboardList(searchingFor: athleteId, onPage: page) { (_, _) in
            navController.popToViewController(leaderboardResultViewController, animated: false)
            leaderboardResultViewController.viewShouldReload(with: viewModelToLoad, scrollingToAthlete: athleteId, onPage: page)
            leaderboardResultViewController.filterViewModel = newFilterViewModel
            tabBarController?.selectedIndex = resultControllerIndex
            completion?()
        }
    }

    private func push(in navigationController: UINavigationController?,
                      presenting leaderboard: CustomLeaderboard,
                      title: String?,
                      subtitle: String?,
                      isAffiliateLeaderboard: Bool,
                      searching athleteId: String?,
                      onPage page: Int?,
                      completion: (() -> Void)? = nil) {
        let layout = LeaderboardResultLayout.minimalLeaderboard(title: title ?? "",
                                                                subtitle: subtitle,
                                                                isAffiliateLeaderboard: isAffiliateLeaderboard)
        guard let leaderboardResultViewController = LeaderboardResultBuilder(layout: layout).build() as? LeaderboardResultViewController else {
            return
        }
        navigationController?.pushViewController(leaderboardResultViewController, animated: true)
        leaderboardResultViewController.loadViewIfNeeded()

        let viewModelToLoad = LeaderboardResultViewModel(customLeaderboard: leaderboard)
        let newFilterViewModel = LeaderboardFilterContent(leaderboard: leaderboard)
        viewModelToLoad.retrieveLeaderboardList(searchingFor: athleteId, onPage: page) { (_, _) in
            leaderboardResultViewController.viewShouldReload(with: viewModelToLoad, scrollingToAthlete: athleteId, onPage: page)
            leaderboardResultViewController.filterViewModel = newFilterViewModel
            completion?()
        }
    }

}
