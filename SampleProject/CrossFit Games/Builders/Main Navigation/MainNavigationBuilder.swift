//
//  MainNavigationBuilder.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/10/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

struct MainNavigationBuilder: Builder {

    func build() -> UIViewController {
        let dashboardViewController = DashboardBuilder().build()
        let dashboardNavigationController = UINavigationController(rootViewController: dashboardViewController)
        dashboardViewController.tabBarItem = UITabBarItem(title: "Home",
                                                          image: #imageLiteral(resourceName: "Home Icon Unselected"),
                                                          selectedImage: #imageLiteral(resourceName: "Home Icon").withRenderingMode(.alwaysOriginal))

        guard let leaderboardResultViewController = LeaderboardResultBuilder(layout: .default)
            .build() as? LeaderboardResultViewController else {
                fatalError("Cannot created LeaderboardContainerViewController")
        }
        AppLayout.global.leaderboardResultViewController = leaderboardResultViewController
        leaderboardResultViewController.tabBarItem = UITabBarItem(title: "Leaderboard",
                                                                  image: #imageLiteral(resourceName: "Leaderboard Icon Unselected"),
                                                                  selectedImage: #imageLiteral(resourceName: "Leaderboard Icon").withRenderingMode(.alwaysOriginal))
        let leaderboardNavigationController = UINavigationController(rootViewController: leaderboardResultViewController)

        guard let workoutContainerViewController = WorkoutContainerBuilder().build() as? WorkoutContainerViewController else {
            fatalError("Cannot created WorkoutContainerViewController")
        }
        workoutContainerViewController.tabBarItem = UITabBarItem(title: "Workouts",
                                                                 image: #imageLiteral(resourceName: "Workout Icon Unselected"),
                                                                 selectedImage: #imageLiteral(resourceName: "Workout Icon").withRenderingMode(.alwaysOriginal))

        let tabBarController = TabBarController()
        let navigationControllers: [UINavigationController] = [leaderboardNavigationController,
                                                               dashboardNavigationController,
                                                               workoutContainerViewController.workoutNavVC]

        navigationControllers.forEach {
            if #available(iOS 11.0, *) {
                $0.navigationBar.prefersLargeTitles = true
            }
            NavBarStyle.default.apply(to: $0.navigationBar)
            $0.navigationBar.titleTextAttributes = StyleGuide.shared.style(row: .r10, column: .c4, weight: .w4)
        }

        dashboardNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        dashboardNavigationController.navigationBar.shadowImage = UIImage()
        workoutContainerViewController.workoutNavVC.navigationBar.isTranslucent = false

        tabBarController.setViewControllers([dashboardNavigationController,
                                             leaderboardNavigationController,
                                             workoutContainerViewController], animated: false)

        return tabBarController
    }

}
