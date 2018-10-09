//
//  WorkoutDataStore.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/31/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Data store for workout data.
final class WorkoutDataStore {

    /// Last available selection of the division.
    var divisionSelection: [WorkoutPhase: String] {
        get {
            guard let data = UserDefaultsManager.shared.getData(byKey: .workoutDivisionSelection) else {
                return [:]
            }
            return (try? PropertyListDecoder().decode([WorkoutPhase: String].self, from: data)) ?? [:]
        }
        set {
            let data = try? PropertyListEncoder().encode(newValue)
            UserDefaultsManager.shared.setValue(withKey: .workoutDivisionSelection, value: data)
        }
    }

    /// Last available selection of `scaled` or `rx'd`.
    var competitionTypeSelection: [WorkoutPhase: String] {
        get {
            guard let data = UserDefaultsManager.shared.getData(byKey: .workoutTypeSelection) else {
                return [:]
            }
            return (try? PropertyListDecoder().decode([WorkoutPhase: String].self, from: data)) ?? [:]
        }
        set {
            let data = try? PropertyListEncoder().encode(newValue)
            UserDefaultsManager.shared.setValue(withKey: .workoutTypeSelection, value: data)
        }
    }

    /// Contains the workouts grouped by year for the selected competition
    var workoutsGroupedByYear: [String: [Workout]]!

}
