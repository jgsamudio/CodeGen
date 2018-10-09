//
//  WorkoutLocalization.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/26/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

struct WorkoutsLocalization {

    /// Live text
    let live = "WORKOUTS_LIVE".localized

    /// Completed text
    let completed = "WORKOUTS_COMPLETED".localized

    /// Show more text
    let showMore = "WORKOUTS_SHOW_MORE".localized

    /// Show less text
    let showLess = "WORKOUTS_SHOW_LESS".localized

    /// View more details text
    let viewMoreDetails = "WORKOUTS_VIEW_MORE_DETAILS".localized

    let open = "WORKOUTS_OPEN".localized

    let theGames = "WORKOUTS_THE_GAMES".localized

    let onlineQualifiers = "WORKOUTS_ONLINE_QUALIFIERS".localized

    let regionals = "WORKOUTS_REGIONALS".localized

    let teamSeries = "WORKOUTS_TEAM_SERIES".localized

    /// Submit score text
    let submitScore = "WORKOUTS_SUBMIT_SCORE".localized

    let submissionDeadline = "WORKOUTS_SUBMISSION_DEADLINE".localized

    /// Localizes `rx` or `scaled` value coming from the API as workout type.
    ///
    /// - Parameter value: Value to localize.
    /// - Returns: Localized value.
    func workoutType(value: String) -> String {
        return value.localized
    }

}
