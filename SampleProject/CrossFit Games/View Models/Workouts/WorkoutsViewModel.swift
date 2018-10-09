//
//  WorkoutsViewModel.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/23/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Contains functions and attributes required to display the list view of the workouts
struct WorkoutsViewModel {

    /// Workout service
    var workoutsService: WorkoutsService

    init() {
        workoutsService = ServiceFactory.shared.createWorkoutsService()
    }

    /// Stores the selected competition
    var selectedCompetition: CompetitionPhase?

    /// Stores the selected year
    var selectedYear: String?

    /// Competition types
    var competitions: [String] {
        return workoutsService.competitions()
    }

    /// Selects the given competition.
    ///
    /// - Parameter division: Division to select.
    mutating func select(competition: String) {
        selectedCompetition = CompetitionPhase.byString(string: competition)
    }

    /// Selects the year
    ///
    /// - Parameter year: Year value to be selected
    mutating func select(year: String) {
        selectedYear = year
    }

    /// Gets workout competitions for a particular cpmpetition phase
    ///
    /// - Parameters:
    ///   - competitionPhase: competition phase
    ///   - completion: the block that contains a dictionary with the competitionss or an error if occurs
    func getWorkoutCompetitons(byCompetitionPhase competionPhase: CompetitionPhase,
                               completion: @escaping (_ competitionFilters: [String: WorkoutCompetition]?, _ error: Error?) -> Void) {
        workoutsService.getWorkoutCompetitions(byCompetitionPhase: competionPhase, completion: { (competitions, error) in
            if error != nil {
                completion(nil, error)
            } else {
                var competitionFilters: [String: WorkoutCompetition] = [:]
                if let competitions = competitions {
                    let filtered = competitions.filter({
                        if let startDate = $0.startDate, startDate <= DatePicker.shared.date {
                            return true
                        }
                        return false
                    })
                    filtered.forEach({
                        competitionFilters[$0.year] = $0
                    })
                    completion(competitionFilters, nil)
                }
            }
        })
    }

    /// Gets the list of workouts for a particular year, by its identifier
    ///
    /// - Parameters:
    ///   - identifier: Unique identifier for a particular year
    func getWorkouts(byIdentifier identifier: String,
                     completion: @escaping (_ workouts: [WorkoutViewModel]?, _ error: Error?) -> Void) {
        var workoutViewModels: [WorkoutViewModel] = []
        workoutsService.getWorkouts(by: identifier, completion: { (workouts, error) in
            if error != nil {
                completion(nil, error)
                return
            }
            guard let workouts = workouts else {
                return
            }
            workouts.forEach({ workout in
                var workoutViewModel = WorkoutViewModel(workout: workout, collapsed: true)
                if workoutViewModel.selectedDivision == nil {
                    workoutViewModel.select(division: "Men (18-34)")
                }
                if workoutViewModel.selectedType == nil {
                    workoutViewModel.select(workoutType: "rx")
                }
                workoutViewModels.append(workoutViewModel)
            })
            completion(workoutViewModels, nil)
        })
    }

    /// Presents the submit score flow in the given view controller.
    ///
    /// - Parameter viewController: View controller from which to present the submit score flow.
    func showSubmitScore(in viewController: UIViewController, completion: @escaping (Error?) -> Void) {
        let submitScoreService = ServiceFactory.shared.createSubmitScoreService()
        submitScoreService.refreshAccessTokenIfPossible { (_, error) in
            if let error = error {
                completion(error)
            } else {
                submitScoreService.presentScoreSubmission(in: viewController)
                completion(nil)
            }
        }
    }

}
