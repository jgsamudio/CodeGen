//
//  WorkoutStatsCell.swift
//  CrossFit Games
//
//  Created by Malinka S on 11/16/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit
import Lottie

final class WorkoutStatsCell: UITableViewCell {

    @IBOutlet private weak var scoreValueLabel: StyleableLabel!
    @IBOutlet private weak var percentileValueLabel: StyleableLabel!
    @IBOutlet private weak var rankValueLabel: StyleableLabel!
    @IBOutlet private weak var workoutNameLabel: StyleableLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }

    private func config() {
        workoutNameLabel.layer.anchorPoint = CGPoint(x: 1, y: 1)
        workoutNameLabel.transform = CGAffineTransform(rotationAngle: -.pi / 2)
    }

    func setData(viewModel: WorkoutStatsViewModel) {
        percentileValueLabel.isHidden = true
        workoutNameLabel.text = viewModel.workoutDisplayName

        if let percentileValue = viewModel.percentileTextValue, !percentileValue.isEmpty {
            percentileValueLabel.isHidden = false
            percentileValueLabel.text = percentileValue
        }

        rankValueLabel.text = viewModel.rank
        scoreValueLabel.text = viewModel.workoutScore
    }

}
