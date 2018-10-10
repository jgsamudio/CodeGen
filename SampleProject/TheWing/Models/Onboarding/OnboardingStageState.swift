//
//  OnboardingStageState.swift
//  TheWing
//
//  Created by Luna An on 7/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Enumerates all possible onboarding stage states.
///
/// - notStarted: Not started.
/// - inProgress: In progress.
/// - completed: Completed.
/// - sectionCompleted: Section completed.
enum OnboardingStageState {
    case notStarted
    case inProgress
    case completed
    case sectionCompleted
}
