//
//  AppLayout.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/16/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Representation of the app layout.
final class AppLayout {

    /// Global App layout. View controllers are set as the UI gets built.
    static let global = AppLayout()

    private init() {}

    /// Common result view controller (The result view controller used when going to the leaderboard tab).
    weak var leaderboardResultViewController: LeaderboardResultViewController?

    /// Tab bar controller used in the app for main navigation.
    weak var tabBarController: UITabBarController?

}
