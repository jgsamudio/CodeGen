//
//  TabBarController.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 1/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Simcoe

/// Tab Bar Controller
class TabBarController: UITabBarController {

    // MARK: - Public Properties
    
    var previousSelectedViewController: UIViewController?

    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

}

// MARK: - UITabBarControllerDelegate
extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if previousSelectedViewController == viewController {
            handleTapEvent(tabBarController, didSelect: viewController)
        }
        previousSelectedViewController = viewController
    }

    func handleTapEvent(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let vcIndex = tabBarController.viewControllers?.index(of: viewController)
        if vcIndex == 0 { // 0 -> Dashboard
            Simcoe.track(event: .dashboardNavigation,
                         withAdditionalProperties: [:], on: .dashboard)
            ((viewController as? UINavigationController)?.visibleViewController as? TabBarTappable)?.handleTabBarTap()
        } else if vcIndex == 1 { // 1 -> Leaderboard
            Simcoe.track(event: .leaderboardNavigation,
                         withAdditionalProperties: [:],
                         on: .leaderboard)
            ((viewController as? UINavigationController)?.visibleViewController as? TabBarTappable)?.handleTabBarTap()
        } else if vcIndex == 2 { // 2 -> Workouts
            Simcoe.track(event: .workoutNavigation,
                         withAdditionalProperties: [:],
                         on: .workoutPages)
            (viewController as? TabBarTappable)?.handleTabBarTap()
        }
    }

}
