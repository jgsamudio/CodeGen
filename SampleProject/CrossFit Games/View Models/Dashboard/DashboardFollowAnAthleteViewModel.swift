//
//  DashboardFollowAnAthleteViewModel.swift
//  CrossFit Games
//
//  Created by Malinka S on 2/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// View model for the dashboard follow an athlete
struct DashboardFollowAnAthleteViewModel {

    /// Athlete Id
    let id: String

    /// Athlete name
    let name: String?

    /// Athlete workouts
    let workouts: [WorkoutScore]?

    /// Athlete's profile image
    let imageUrl: URL?

    /// Selected division
    let division: String?

    /// total number of athletes
    let totalAthleteCount: Int

    /// Overall rank of the user
    let rank: String?

    /// Relevant ordinals for the filters
    let ordinals: [LeaderboardOrdinal]

    /// Returns the latest workout of the particular athlete
    var latestWorkout: [String: WorkoutScore?]? {
        if let workouts = workouts {
            let sortedWorkout = workouts.sorted(by: { Double($0.ordinalID) ?? 0 > Double($1.ordinalID) ?? 0 }).first ?? nil
            let ordinalName = ordinals.filter({ $0.id == sortedWorkout?.ordinalID }).first?.displayName ?? ""
            return [ordinalName: sortedWorkout]
        }
        return nil
    }

    /// Formatted the workouts so that it could be read as an array of dictionaries
    var formattedWorkouts: [[String: WorkoutScore?]] {
        var ordinalMapArray: [[String: WorkoutScore?]] = []
        if let workouts = workouts {
            workouts.forEach({ workout in
                if let ordinal = ordinals.first(where: { $0.id == workout.ordinalID }) {
                    ordinalMapArray.append([ordinal.displayName: workout])
                }
            })
        }
        return ordinalMapArray
    }

    /// Removes the current following athlete
    func unfollowAthlete() {
        let followAthleteService = ServiceFactory.shared.createFollowAnAthleteService()
        followAthleteService.unFollowAthlete()
    }

}
