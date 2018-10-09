//
//  WorkoutContainerBuilder.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 12/17/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Builds Workout Container View Controller
struct WorkoutContainerBuilder: Builder {
    
    // MARK: - Public Functions
    
    func build() -> UIViewController {
    
    // MARK: - Public Properties
    
        let storyboard = UIStoryboard(name: "Workouts", bundle: nil)
        let viewController: WorkoutContainerViewController = storyboard.instantiateViewController()
        return viewController
    }
    
}
