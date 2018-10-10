//
//  WorkoutDetailsBuilder.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/18/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

struct WorkoutDetailsBuilder: Builder {

    // MARK: - Public Properties
    
    let viewModel: WorkoutViewModel

    // MARK: - Public Functions
    
    func build() -> UIViewController {
        let storyboard = UIStoryboard(name: "Workouts", bundle: nil)
        let viewController: WorkoutDetailsViewController = storyboard.instantiateViewController()
        viewController.viewModel = viewModel
        return viewController
    }

}
