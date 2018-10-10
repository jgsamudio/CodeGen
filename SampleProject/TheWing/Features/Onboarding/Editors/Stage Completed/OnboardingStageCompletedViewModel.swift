//
//  OnboardingStageCompletedViewModel.swift
//  TheWing
//
//  Created by Paul Jones on 7/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct OnboardingStageCompletedViewModel {
    
    // MARK: - Public Properties
    
    /// What stage does this view model represent?
    var stage: OnboardingProgressStage
    
    /// Should the progress view be hidden for the stage you sent?
    var progressViewShouldBeHidden: Bool {
        switch stage {
        case .asksAndOffers:
            return true
        default:
            return false
        }
    }
    
    /// What's the title label text?
    var titleLabelText: String {
        switch stage {
        case .aboutYou:
            return OnboardingLocalization.completedAboutYouTitleText
        case .asksAndOffers:
            return OnboardingLocalization.completedAsksOffersTitleText
        case .basics:
            return OnboardingLocalization.completedBasicsTitleText
        }
    }
    
    /// What's the body label text?
    var bodyLabelText: String {
        switch stage {
        case .aboutYou:
            return OnboardingLocalization.completedAboutYouBodyText
        case .asksAndOffers:
            return OnboardingLocalization.completedAsksOffersBodyText
        case .basics:
            return OnboardingLocalization.completedBasicsBodyText
        }
    }

}

// MARK: - AnalyticsIdentifiable
extension OnboardingStageCompletedViewModel: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        switch stage {
        case .aboutYou:
            return AnalyticsScreen.onboardingAboutYouCompleted.analyticsIdentifier
        case .asksAndOffers:
            return AnalyticsScreen.onboardingAsksOffersCompleted.analyticsIdentifier
        case .basics:
            return AnalyticsScreen.onboardingBasicsCompleted.analyticsIdentifier
        }
    }
    
}
