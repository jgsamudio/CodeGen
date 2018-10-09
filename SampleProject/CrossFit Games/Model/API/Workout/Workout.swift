//
//  Workout.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/23/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Workout details as returned from
/// http://games-drupal.crossfit.com/api/v1/competitionworkouts
struct Workout: Decodable {

    private enum CodingKeys: String, CodingKey {
        case workoutSteps = "workouts"
        case workoutYears = "year"
        case youtubeVideoId = "youtube_video_id"
        case sponsorImages = "image_sponsor_logo"
        case workoutDescription = "workout"
        case videoSubmissionStandards = "video_submission_standards"
        case workoutSummary = "workout_summary"
        case equipment
        case tiebreak
        case id
        case label
        case created
        case changed
        case type
        case phase = "competition_phase"
        case workoutImageURL
        case mediaPreview = "media_preview"
        case pdf
        case start_date
        case end_date
        case pdfURL = "pdf_link"
        case sponsorURL = "sponsor_url"
        case movementStandardImages = "images_movement"
    }

    /// Workout id
    let id: String

    /// Workout title
    let label: String

    /// Workout created time
    let created: String

    /// Workout updated time
    let changed: String

    /// Workout year
    let workoutYears: [WorkoutYear]

    /// Workout phase
    let phase: [WorkoutPhase]

    /// Workout steps
    let workoutSteps: [WorkoutStep]

    let startDate: Date?

    let endDate: Date?

    /// Youtube video ID
    let youtubeVideoId: String?

    /// Sponsor images
    let sponsorImages: [SponsorImage]

    /// Workout description
    let workoutDescription: String

    /// Submission standrards for workout video
    let videoSubmissionStandards: String?

    /// Required equipment to complete the workout
    let equipment: String?

    /// Tiebreak details
    let tiebreak: String?

    /// Workout summary
    let workoutSummary: String

    /// Workout image URL
    let workoutImageURL: String?

    /// PDF URL
    let pdfURL: String?

    /// Sponsor URL
    let sponsorURL: String?

    /// Movement standard images.
    let movementStandardImages: [MovementStandardImage]

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            id = try values.decode(String.self, forKey: .id)
            label = try values.decode(String.self, forKey: .label)
            created = try values.decode(String.self, forKey: .created)
            changed = try values.decode(String.self, forKey: .changed)
            phase = try values.decode([WorkoutPhase].self, forKey: .phase)
            workoutSteps = (try? values.decode([WorkoutStep?].self, forKey: .workoutSteps).flatMap { $0 }) ?? []
            workoutYears = try values.decode([WorkoutYear].self, forKey: .workoutYears)
            youtubeVideoId = try values.decodeIfPresent(String.self, forKey: .youtubeVideoId)
            sponsorImages = (try? values.decode([SponsorImage].self, forKey: .sponsorImages)) ?? []
            workoutDescription = try values.decode(String.self, forKey: .workoutDescription)
            videoSubmissionStandards = try values.decodeIfPresent(String.self, forKey: .videoSubmissionStandards)
            equipment = try values.decodeIfPresent(String.self, forKey: .equipment)
            tiebreak = try values.decodeIfPresent(String.self, forKey: .tiebreak)
            workoutSummary = try values.decode(String.self, forKey: .workoutSummary)
            pdfURL = try values.decodeIfPresent(String.self, forKey: .pdfURL)
            startDate = try values.decodeIfPresentAllowString(Int.self, forKey: .start_date).flatMap {
                Date(timeIntervalSince1970: TimeInterval($0))
            }
            endDate = try values.decodeIfPresentAllowString(Int.self, forKey: .end_date).flatMap {
                Date(timeIntervalSince1970: TimeInterval($0))
            }

            do {
                let mediaPreview = try values.decodeIfPresent([MediaPreview].self, forKey: .mediaPreview)
                workoutImageURL = mediaPreview?.first?.url
            } catch DecodingError.typeMismatch(_, _) {
                workoutImageURL = nil
            }

            do {
                sponsorURL = try values.decodeIfPresent(String.self, forKey: .sponsorURL)
            } catch DecodingError.typeMismatch(_, _) {
                sponsorURL = nil
            }

            movementStandardImages = try values.decode([MovementStandardImage].self, forKey: .movementStandardImages)
        } catch {
            print(error)
            throw error
        }
    }

}
