//
//  WorkoutLoaderBuilder.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 12/17/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Builds Workout Loader View Controller
struct WorkoutLoaderBuilder: Builder {
    
    // MARK: - Public Functions
    
    func build() -> UIViewController {
    
    // MARK: - Public Properties
    
        let storyboard = UIStoryboard(name: "Workouts", bundle: nil)
        let viewController: WorkoutLoaderViewController = storyboard.instantiateViewController()
        return viewController
    }
    
}
