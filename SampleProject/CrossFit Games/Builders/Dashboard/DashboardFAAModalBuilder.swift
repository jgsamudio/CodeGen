//
//  DashboardFAAModalBuilder.swift
//  CrossFit Games
//
//  Created by Malinka S on 2/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

struct DashboardFAAModalBuilder: Builder {

    let viewModel: DashboardFollowAnAthleteViewModel

    func build() -> UIViewController {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let viewController: DashboardFAAModalViewController = storyboard.instantiateViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
