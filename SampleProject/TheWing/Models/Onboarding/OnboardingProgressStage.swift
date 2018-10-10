//
//  OnboardingProgressStage.swift
//  TheWing
//
//  Created by Paul Jones on 7/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Represents a stage in the onboarding process.
///
/// - basics: Basics stage.
/// - aboutYou: About You stage.
/// - asksAndOffers: Asks and Offers stage.
enum OnboardingProgressStage {
    case basics(OnboardingStageState)
    case aboutYou(OnboardingStageState)
    case asksAndOffers(OnboardingStageState)
    
    // MARK: - Public Functions
    
    /// Moves this progress stage to completed state, useful for setting the progress bar to done in complete VC.
    mutating func completeSection() {
        switch self {
        case .basics:
            self = .basics(.sectionCompleted)
        case .aboutYou:
            self = .aboutYou(.sectionCompleted)
        case .asksAndOffers:
            self = .asksAndOffers(.sectionCompleted)
        }
    }

}
