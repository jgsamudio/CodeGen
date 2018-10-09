//
//  FollowAnAthleteModalBuilder.swift
//  CrossFit Games
//
//  Created by Malinka S on 2/7/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Builds the view controller for Follow An Athlete
struct FollowAnAthleteModalBuilder: Builder {

    // MARK: - Public Properties
    
    let viewModel: FollowAnAthleteViewModel

    // MARK: - Public Functions
    
    func build() -> UIViewController {
        let storyboard = UIStoryboard(name: "Leaderboard", bundle: nil)
        let viewController: FollowAnAthleteModalViewController = storyboard.instantiateViewController()
        viewController.viewModel = viewModel
        return viewController
    }

}
