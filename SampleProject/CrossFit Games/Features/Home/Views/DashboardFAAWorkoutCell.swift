//
//  DashboardFAAWorkoutCell.swift
//  CrossFit Games
//
//  Created by Malinka S on 2/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Displays athlete workout information
final class DashboardFAAWorkoutCell: UITableViewCell {

    @IBOutlet private weak var scoreLabel: StyleableLabel!
    @IBOutlet private weak var rankLabel: StyleableLabel!
    @IBOutlet private weak var workoutTitleLabel: StyleableLabel!

    /// Sets data to be displayed in the cell
    ///
    /// - Parameters:
    ///   - workoutScore: Instance of the relevant workout score
    ///   - title: Workout title
    func setData(with workoutScore: WorkoutScore, title: String) {
        workoutTitleLabel.text = title
        switch workoutScore.workoutRank {
        case "WD", "DQ":
            rankLabel.text = workoutScore.workoutRank
        default:
            rankLabel.text = Int(workoutScore.workoutRank)?.format()
        }
        scoreLabel.text = workoutScore.scoreDisplay.isEmpty == true ? "-" : workoutScore.scoreDisplay
    }

}
