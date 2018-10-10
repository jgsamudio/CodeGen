//
//  OnboardingProgressStep.swift
//  TheWing
//
//  Created by Luna An on 7/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

// Enumerates all possible onboarding progress steps.
///
/// - photo: Photo step.
/// - occupation: Occupation step.
/// - industry: Industry step.
/// - social: Social step.
/// - interests: Interests step.
/// - neighborhood: Neighborhood step.
/// - bio: Bio step.
/// - asks: Asks step.
/// - offers: Offers step.
enum OnboardingProgressStep: Int {
    case photo = 1
    case occupation
    case industry
    case social
    case interests
    case neighborhood
    case bio
    case asks
    case offers
    
    // MARK: - Public Properties
    
    /// All onboarding steps.
    static var allSteps = [OnboardingProgressStep.photo,
                           .occupation,
                           .industry,
                           .social,
                           .interests,
                           .neighborhood,
                           .bio,
                           .asks,
                           .offers]
    
    /// Progress to display on each step between 0 and 1.
    var progress: Float {
        return Float(rawValue) / Float(OnboardingProgressStep.allSteps.count)
    }
    
}

// MARK: - AnalyticsIdentifiable
extension OnboardingProgressStep: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        switch self {
        case .photo:
            return AnalyticsScreen.onboardingPhoto.analyticsIdentifier
        case .occupation:
            return AnalyticsScreen.onboardingOccupation.analyticsIdentifier
        case .industry:
            return AnalyticsScreen.onboardingIndustry.analyticsIdentifier
        case .social:
            return AnalyticsScreen.onboardingSocial.analyticsIdentifier
        case .interests:
            return AnalyticsScreen.onboardingInterests.analyticsIdentifier
        case .neighborhood:
            return AnalyticsScreen.onboardingNeighborhood.analyticsIdentifier
        case .bio:
            return AnalyticsScreen.onboardingBio.analyticsIdentifier
        case .asks:
            return AnalyticsScreen.onboardingAsks.analyticsIdentifier
        case .offers:
            return AnalyticsScreen.onboardingOffers.analyticsIdentifier
        }
    }
    
}

