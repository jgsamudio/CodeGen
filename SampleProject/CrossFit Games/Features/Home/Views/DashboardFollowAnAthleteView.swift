//
//  DashboardFollowAnAthleteView.swift
//  CrossFit Games
//
//  Created by Malinka S on 2/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// View to display the following athlete's information
final class DashboardFollowAnAthleteView: UIView {

    @IBOutlet private weak var innerView: UIView!
    @IBOutlet private weak var nameLabel: StyleableLabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var workoutRankLabel: StyleableLabel!
    @IBOutlet private weak var workoutTitleLabel: StyleableLabel!
    @IBOutlet private weak var workoutScoreLabel: StyleableLabel!

    /// Initializes an instance of DashboardFollowAnAthleteView from the nib file
    ///
    /// - Returns: An instance of DashboardFollowAnAthleteView
    func initFromNib() -> DashboardFollowAnAthleteView? {
        guard let view = UINib(nibName: String(describing: DashboardFollowAnAthleteView.self), bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as? DashboardFollowAnAthleteView else {
                return nil
        }
        view.innerView.applyBorder(withColor: .white, borderWidth: 1)
        return view
    }

    /// Sets following athlete data if available
    ///
    /// - Parameter athlete: Dashboard follow an athlete view model
    func setAthleteData(with athlete: DashboardFollowAnAthleteViewModel) {
        nameLabel.text = athlete.name
        profileImageView.download(imageURL: athlete.imageUrl)
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true

        if let latestWorkouts = athlete.latestWorkout, !latestWorkouts.isEmpty,
            let latestWorkout = latestWorkouts.first {
            workoutTitleLabel.text = latestWorkout.key
            workoutRankLabel.text = Int(latestWorkout.value?.workoutRank ?? "")?.format()
            workoutScoreLabel.text = latestWorkout.value?.scoreDisplay.isEmpty == true ? "-" : latestWorkout.value?.scoreDisplay
        }
    }

}
