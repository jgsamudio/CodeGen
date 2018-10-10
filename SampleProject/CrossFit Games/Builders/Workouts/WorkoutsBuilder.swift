//
//  WorkoutsBuilder.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/10/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

struct WorkoutsBuilder: Builder {

    // MARK: - Public Functions
    
    func build() -> UIViewController {
    
    // MARK: - Public Properties
    
        let workoutsViewController: WorkoutsViewController = UIStoryboard(name: "Workouts", bundle: nil).instantiateViewController()
        workoutsViewController.viewModel = WorkoutsViewModel()

        return workoutsViewController
    }

}
