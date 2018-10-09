//
//  WorkoutStep.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/23/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Step details which are needed to complete a workout
struct WorkoutStep: Codable {

    // MARK: - Public Properties
    
    /// Desciption of what needs to be done in a particular step
    let steps: String

    /// Type of step (Ex: rx, scaled)
    let type: String?

    /// List of divisions for a particular workout step
    let division: [Division]
    
}
