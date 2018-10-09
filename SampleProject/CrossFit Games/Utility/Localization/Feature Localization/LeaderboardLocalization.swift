//
//  LeaderboardLocalization.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/25/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Localization constants for leaderboard feature.
struct LeaderboardLocalization {

    /// String "Leader" to show in the UI on the left edge of the leader's leaderboard cell.
    let leader = "LEADERBOARD_LEADER".localized

    let searchPlaceholder = "SEARCH_PLACEHOLDER".localized

    let sortedBy = "LEADERBOARD_SORTED_BY".localized

    let filtersNoResults = "LEADERBOARD_FILTERS_NO_RESULTS_FOUND".localized

    let searchNoResults = "SEARCH_NO_RESULTS".localized

    let faaCannotFollowError = "LEADERBOARD_FAA_CANNOT_FOLLOW_ERROR".localized

    /// Localized string for the age of a user.
    ///
    /// - Parameter age: Age string with a numeric value in it.
    /// - Returns: Formatted, localized age.
    func ageString(age: String) -> String {
        return String.localizedStringWithFormat("LEADERBOARD_AGE_FORMAT".localized, age)
    }

    /// Localizes "34" into "34 points"
    ///
    /// - Parameter nPoints: Plain points string.
    /// - Returns: Points with "points" attached to properly show points.
    func points(nPoints: String) -> String {
        return String.localizedStringWithFormat("LEADERBOARD_POINTS_FORMAT".localized, nPoints)
    }

    /// Localizes now following athlete name
    ///
    /// - Parameter athlete: Athlete name
    /// - Returns: Localized athlete name
    func nowFollowing(with athlete: String) -> String {
        return String.localizedStringWithFormat("LEADERBOARD_NOW_FOLLOWING".localized, athlete)
    }

}
