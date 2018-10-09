//
//  DashboardFAAModalBuilder.swift
//  CrossFit Games
//
//  Created by Malinka S on 2/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

struct DashboardFAAModalBuilder: Builder {

    // MARK: - Public Properties
    
    let viewModel: DashboardFollowAnAthleteViewModel

    // MARK: - Public Functions
    
    func build() -> UIViewController {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let viewController: DashboardFAAModalViewController = storyboard.instantiateViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
