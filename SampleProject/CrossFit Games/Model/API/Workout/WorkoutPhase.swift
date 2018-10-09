//
//  WorkoutPhase.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/23/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Represents the type of workout (Ex: Open, Online Qualifiers, The Games)
struct WorkoutPhase: Codable {

    /// Phase name
    let label: String

    /// Phase description
    let description: String?

}

// MARK: - Hashable
extension WorkoutPhase: Hashable {

    var hashValue: Int {
        return label.hash
    }

}

func == (_ lhs: WorkoutPhase, _ rhs: WorkoutPhase) -> Bool {
    return lhs.label == rhs.label
}
