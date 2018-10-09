//
//  DashboardBuilder.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/10/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

struct DashboardBuilder: Builder {

    // MARK: - Public Functions
    
    func build() -> UIViewController {
    
    // MARK: - Public Properties
    
        let dashboardViewController: DashboardViewController = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController()
        dashboardViewController.viewModel = DashboardViewModel()
        return dashboardViewController
    }

}
