//
//  WorkoutsService.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/23/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

struct WorkoutsService {

    let httpClient: HTTPClientProtocol

    let dataStore: WorkoutDataStore

    private var selectedDivision: String?

    private var selectedType: String?

    private let workoutsURL = "competitions/api/v1/competitions"

    init(httpClient: HTTPClientProtocol, dataStore: WorkoutDataStore) {
        self.httpClient = httpClient
        self.dataStore = dataStore
    }

    /// Workouts grouped by year for a selected competitions
    var workoutsGroupedByYear: [String: [Workout]] {
        set {
            dataStore.workoutsGroupedByYear = workoutsGroupedByYear
        }
        get {
            return dataStore.workoutsGroupedByYear
        }
    }

    /// Sets the workouts grouped by year in the workout datastore
    ///
    /// - Parameter workoutsGrouped: grouped workout
    func setWorkoutsGroupedByYear(_ workoutsGrouped: [String: [Workout]]) {
        dataStore.workoutsGroupedByYear = workoutsGrouped
    }

    /// Get workout competitions by phase
    ///
    /// - Parameters:
    ///   - competitionPhase: Phase (open, the games etc)
    ///   - completion: completion block which returns the list of workouts and the error if occurs
    func getWorkoutCompetitions(byCompetitionPhase competitionPhase: CompetitionPhase,
                                completion: @escaping (_ competitions: [WorkoutCompetition]?, _ error: Error?) -> Void) {
        let requestURL = CFEnvironmentManager.shared.currentGeneralEnvironment.baseURL
            .appendingPathComponent(workoutsURL).appendingPathComponent(competitionPhase.rawValue)
        let httpRequest = HTTPRequest(url: requestURL,
                                      method: .get,
                                      body: nil,
                                      headers: nil,
                                      encoding: .urlEncoding,
                                      allowCaching: false,
                                      allowURLCaching: false)

        httpClient.requestJson(request: httpRequest, isAuthRequest: false, completion: { (response: [WorkoutCompetition]?, _, error) in
            if error != nil {
                completion(nil, error)
            } else {
                completion(response, nil)
            }
        })
    }

    /// Gets workouts by identifier
    ///
    /// - Parameters:
    ///   - identifier: Unique identifier for a particular competition year
    ///   - completion: completion block which includes workouts or an error
    func getWorkouts(by identifier: String,
                     completion: @escaping ( _ workouts: [Workout]?, _ error: Error?) -> Void) {
        let requestURL = CFEnvironmentManager.shared.currentGeneralEnvironment.baseURL
            .appendingPathComponent(workoutsURL)
            .appendingPathComponent(identifier)
            .appendingPathComponent("workouts")
        let httpRequest = HTTPRequest(url: requestURL,
                                      method: .get,
                                      body: nil,
                                      headers: nil,
                                      encoding: .urlEncoding,
                                      allowCaching: false,
                                      allowURLCaching: false)

        httpClient.requestJson(request: httpRequest, isAuthRequest: false, completion: { (response: [Workout]?, _, error) in
            if error != nil {
                completion(nil, error)
            } else {
                completion(response, nil)
            }
        })
    }

    /// Returns true if workout is live
    ///
    /// - Parameter workout: workout instance
    /// - Returns: live status
    func isLiveWorkout(workout: Workout) -> Bool {
        guard let deadline = workout.endDate else {
            return false
        }
        return DatePicker.shared.date <= deadline
    }

    /// Returns true/false based on the workout is completed
    ///
    /// - Parameter workout: workout instance
    /// - Returns: completed
    func isWorkoutCompleted(workout: Workout) -> Bool {
        guard let deadline = workout.endDate else {
            return true
        }
        return DatePicker.shared.date > deadline
    }

    /// Filters the workout steps by division
    ///
    /// - Parameters:
    ///   - division: The division a aprticular workout step belongs to
    ///   - workoutSteps: original/ungrouped workout steps
    /// - Returns: filtered workout steps array
    func filterWorkoutStepsByDivision(division: String, workoutSteps: [WorkoutStep]) -> [WorkoutStep]? {
        let workoutStepsByDivision = arrangeWorkoutByDivisions(workoutSteps: workoutSteps)
        var division = division
        if !workoutStepsByDivision.contains(where: { $0.key == division }) {
            division = workoutStepsByDivision.keys.first ?? ""
        }
        return workoutStepsByDivision[division]
    }

    /// Retrieves divisions for the given workout.
    ///
    /// - Parameter workout: Workout to get a list of available divisions from.
    /// - Returns: List of division options to select from.
    func divisions(for workout: Workout) -> [String] {
        return prepareDistinctDivisionList(workoutSteps: workout.workoutSteps)
    }

    /// Retrieves workout types for the given workout.
    ///
    /// - Parameter workout: Workout to get a list of available workout types from.
    /// - Returns: List of workout types to select from.
    func workoutTypes(for workout: Workout) -> [String] {
        return workout.workoutSteps.map { $0.type }.reduce([String?](), { (result, element) -> [String?] in
            var _result = result
            if _result.contains(where: { element == $0 }) {
                return _result
            } else {
                _result.append(element)
                return _result
            }
        }).flatMap { $0 }
    }

    /// Returns the available competition types
    ///
    /// - Returns: array of localized competition types
    func competitions() -> [String] {
        let localization = WorkoutsLocalization()
        return [CompetitionPhase.open.localize(localization: localization),
                CompetitionPhase.theGames.localize(localization: localization),
                CompetitionPhase.onlineQualifiers.localize(localization: localization),
                CompetitionPhase.regionals.localize(localization: localization),
                CompetitionPhase.teamSeries.localize(localization: localization)]
    }

    /// Selects (and persists) the given division selection for the selected workout.
    ///
    /// - Parameters:
    ///   - division: Division to persist.
    ///   - workout: Workout whose phase will be assigned with the selection.
    mutating func select(division: String, for workout: Workout) {
        selectedDivision = division
    }

    /// Returns the last selection (if available) a user made on the given workout.
    ///
    /// - Parameter workout: Workout the user made a selection for.
    /// - Returns: Division the user selected.
    func selectedDivision(for workout: Workout) -> String? {
        return selectedDivision
    }

    /// Selects (and persists) the given type selection for the selected workout.
    ///
    /// - Parameters:
    ///   - type: Workout type to persist.
    ///   - workout: Workout whose phase will be assigned with the selection.
    mutating func select(type: String, for workout: Workout) {
        selectedType = type
    }

    /// Returns the last selection (if available) a user made on the given workout.
    ///
    /// - Parameter workout: Workout the user made a selection for.
    /// - Returns: Workout type the user selected.
    func selectedType(for workout: Workout) -> String? {
        return selectedType
    }

    private func arrangeWorkoutByDivisions(workoutSteps: [WorkoutStep]) -> [String: [WorkoutStep]] {
        let distinctDivisions = prepareDistinctDivisionList(workoutSteps: workoutSteps)
        var stepsByDivision: [String: [WorkoutStep]] = [:]
        distinctDivisions.forEach({division in
            stepsByDivision[division] = []
            workoutSteps.forEach({ workoutStep in
                if (workoutStep.division.contains { $0.label == division }) {
                    stepsByDivision[division]?.append(workoutStep)
                }
            })
        })
        return stepsByDivision
    }

    private func prepareDistinctDivisionList(workoutSteps: [WorkoutStep]) -> [String] {
        let allDivisions = Array(workoutSteps.map { $0.division }.joined())
        return allDivisions.map { $0.label }.reduce([String](), { (result, value) -> [String] in
            var _result = result
            if _result.contains(value) {
                return _result
            } else {
                _result.append(value)
                return _result
            }
        })
    }
    
}
