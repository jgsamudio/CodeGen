//
//  WorkoutCellViewModel.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/23/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Contains the required attributes to display workout details
struct WorkoutViewModel {

    // MARK: - Public Properties
    
    /// Workout
    let workout: Workout

    /// Specifies if the workout cell is collapsed or not
    var collapsed: Bool = true

    /// workout youtube video id
    var videoId: String? {
        return workout.youtubeVideoId
    }

    /// Returns the divisions to select from.
    var divisions: [String] {
        return workoutsService.divisions(for: workout).sorted()
    }

    /// Returns the workout types to select from.
    var workoutTypes: [String] {
        return workoutsService.workoutTypes(for: workout)
    }

    /// Sponsor image URL
    var sponsorImageURL: URL? {
        if let urlString = workout.sponsorImages.first?.imageURL {
            return URL(string: urlString)
        }
        return nil
    }

    /// Sponsor URL
    var sposorURL: URL? {
        if let sponsorURL = workout.sponsorURL {
            return URL(string: sponsorURL)
        }
        return nil
    }

    /// Workout image URL
    var workoutImageURL: URL? {
        if let workoutImageURL = workout.workoutImageURL {
            return URL(string: workoutImageURL)
        }
        return nil
    }

    /// URL of the PDF which contains workout details and scorecard information
    var pdfURL: URL? {
        if let pdfURL = workout.pdfURL {
            return URL(string: pdfURL)
        }
        return nil
    }

    /// Workout title to be displayed
    var title: String? {
        return workout.label
    }

    /// Specifies if the workout is completed or not
    var isCompleted: Bool {
        return workoutsService.isWorkoutCompleted(workout: workout)
    }

    /// Specifies if the workout is live or not
    var isLiveWorkout: Bool {
        return workoutsService.isLiveWorkout(workout: workout)
    }

    /// Formatted submission time
    var formattedSubmissionTime: String? {
        guard let deadline = workout.endDate else {
            return nil
        }
        let monthDay = DateTime.convertToString(timeZone: nil, date: deadline, format: "EEE, MMM dd")
        let time = DateTime.convertToString(timeZone: nil, date: deadline, format: "h:mm a")
        return "\(monthDay)\n\(time) \(DateTime.getCurrentTimeZone() ?? "")"
    }

    /// Previously selected division.
    var selectedDivision: String? {
        return workoutsService.selectedDivision(for: workout)
    }

    /// Previously selected type.
    var selectedType: String? {
        return workoutsService.selectedType(for: workout)
    }

    // MARK: - Private Properties
    
    private var workoutsService: WorkoutsService = ServiceFactory.shared.createWorkoutsService()

    // MARK: - Initialization
    
    init(workout: Workout, collapsed: Bool) {
        self.workout = workout
        self.collapsed = collapsed
    }

    // MARK: - Public Functions
    
    /// Selects the given division and persists the selection.
    ///
    /// - Parameter division: Division to select.
    mutating func select(division: String) {
        workoutsService.select(division: division, for: workout)
    }

    /// Selects the given workout type and persists the selection.
    ///
    /// - Parameter division: Workout type to select.
    mutating func select(workoutType: String) {
        workoutsService.select(type: workoutType, for: workout)
    }
    
    /// Equipment required for the workout
    var equipment: NSAttributedString? {
        guard let equipment = workout.equipment else {
            return nil
        }
        return StringConverter.crossFitStyleHTMLString(htmlEncodedString: equipment)
    }

    /// Video submission standards for the workout
    var videoSubmissionStandards: NSAttributedString? {
        guard let videoSubmissionStandards = workout.videoSubmissionStandards else {
            return nil
        }
        return StringConverter.crossFitStyleHTMLString(htmlEncodedString: videoSubmissionStandards)
    }

    /// Workout description
    var workoutDescription: NSAttributedString? {
        return StringConverter.crossFitStyleHTMLString(htmlEncodedString: workout.workoutDescription)
    }

    /// Workout tiebreak
    var tiebreak: NSAttributedString? {
        guard let tiebreak = workout.tiebreak else {
            return nil
        }
        return StringConverter.crossFitStyleHTMLString(htmlEncodedString: tiebreak)
    }

    /// Movement standard image URLs for `self`.
    var workoutStandardImages: [URL?] {
        return workout.movementStandardImages.map { $0.imageUrl }
    }

    /// Workout standard descriptions for `self`.
    var workoutStandardDescriptions: [String] {
        return workout.movementStandardImages.map { $0.title }
    }

    /// Filters workout steps by division and the type
    ///
    /// - Parameters:
    ///   - division: division of a particular step
    ///   - type: type of the workout step
    /// - Returns: attributed string after parsing the HTML content
    func workoutStepDescription(byDivision division: String, andType type: String) -> NSAttributedString? {
        let workoutSteps = workoutsService.filterWorkoutStepsByDivision(division: division, workoutSteps: workout.workoutSteps)

        var workoutStepsString = ""
        workoutSteps?.forEach({workoutStep in
            if type == workoutStep.type {
                workoutStepsString.append(workoutStep.steps)
            }
        })

        return StringConverter.crossFitStyleHTMLString(htmlEncodedString: workoutStepsString)
    }

    /// Presents a login screen in the given view controller.
    ///
    /// - Parameters:
    ///   - viewController: View controller to present the login view in.
    ///   - completion: Completion block that is called when the user logged in or opted out of the login.
    func presentScoreSubmission(in viewController: UIViewController, completion: @escaping (Error?) -> Void) {
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
