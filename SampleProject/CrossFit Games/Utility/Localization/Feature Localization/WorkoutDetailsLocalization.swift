//
//  WorkoutDetailsLocalization.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/31/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

struct WorkoutDetailsLocalization {

    /// Equioment text
    let equipment = "WORKOUT_DETAILS_EQUIPMENT".localized

    /// Video submission standards text
    let videoSubmissionStandards = "WORKOUT_DETAILS_VIDEO_SUBMISSION_STANDARDS".localized

    /// Movement standard text for the segment control
    let movementStandards = "WORKOUT_DETAILS_MOVEMENT_STANDARDS".localized

    /// Workout description text for the segment control
    let workoutDescription = "WORKOUT_DETAILS_WORKOUT_DESCRIPTION".localized

    /// Download text
    let download = "WORKOUT_DETAILS_DOWNLOAD".localized

    /// scorecard PDF text
    let scorecardPDF = "WORKOUT_DETAILS_SCORECARD_PDF".localized

    /// Sponsored by text
    let sponsoredBy = "WORKOUT_DETAILS_SPONSORED_BY".localized

    /// Submit score text
    let submitScore = "WORKOUTS_SUBMIT_SCORE".localized

    /// Returns a string à la "1 of 15".
    ///
    /// - Parameters:
    ///   - step: Step.
    ///   - totalSteps: Number of total steps.
    /// - Returns: Localized string.
    func step(_ step: Int, outOf totalSteps: Int) -> String {
        return String.localizedStringWithFormat("WORKOUT_X_OF_N".localized, step, totalSteps)
    }

    /// Returns the localized submission time text
    ///
    /// - Parameter time: time string
    /// - Returns: returns localized text for the submission time
    func submissionTimeString(time: String) -> String {
        return String.localizedStringWithFormat("WORKOUTS_SUBMISSION_TIME".localized, time)
    }

}
