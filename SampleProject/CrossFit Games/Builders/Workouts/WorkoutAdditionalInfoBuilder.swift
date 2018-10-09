//
//  WorkoutAdditionalInfoBuilder.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/31/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

struct WorkoutAdditionalInfoBuilder: Builder {

    // MARK: - Public Properties
    
    /// Content to set in the view controller
    let content: NSAttributedString

    // MARK: - Public Functions
    
    func build() -> UIViewController {
        let storyboard = UIStoryboard(name: "Workouts", bundle: nil)
        let viewController: WorkoutAdditionalInfoViewController = storyboard.instantiateViewController()
        viewController.content = content
        return viewController
    }
}
