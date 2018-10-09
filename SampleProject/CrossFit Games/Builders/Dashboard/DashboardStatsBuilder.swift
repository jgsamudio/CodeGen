//
//  DashboardStatsBuilder.swift
//  CrossFit Games
//
//  Created by Malinka S on 11/13/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

struct DashboardStatsBuilder: Builder {

    let viewModel: DashboardCardViewModel

    func build() -> UIViewController {
        let dashboardStatsViewController: DashboardStatsViewController = UIStoryboard(name: "DashboardStats", bundle: nil).instantiateViewController()
        dashboardStatsViewController.viewModel = DashboardStatsViewModel(dashboardCardViewModel: viewModel)
        return dashboardStatsViewController
    }
}
