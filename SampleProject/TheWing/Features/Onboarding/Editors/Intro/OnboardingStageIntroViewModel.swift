//
//  OnboardingStageIntroViewModel.swift
//  TheWing
//
//  Created by Paul Jones on 7/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct OnboardingStageIntroViewModel {
    
    // MARK: - Public Properties
    
    /// What stage is this view supposed to represent?
    let stage: OnboardingProgressStage
    
    /// Title caption label text
    var titleCaptionLabelText: String {
        switch stage {
        case .aboutYou:
            return OnboardingLocalization.introAboutYouTitleCaptionLabelText
        case .asksAndOffers:
            return OnboardingLocalization.introAsksOffersTitleLabelText
        case .basics:
            return OnboardingLocalization.introBasicsTitleCaptionLabelText
        }
    }
    
    /// Title label text
    var titleLabelText: String {
        switch stage {
        case .aboutYou:
            return OnboardingLocalization.introAboutYouTitleLabelText
        case .asksAndOffers:
            return "" // intentionally left blank.
        case .basics:
            return OnboardingLocalization.introBasicsTitleLabelText
        }
    }
    
    /// Body label text
    var bodyLabelText: String {
        switch stage {
        case .aboutYou:
            return OnboardingLocalization.introAboutYouBodyLabelText
        case .asksAndOffers:
            return OnboardingLocalization.introAsksOffersBodyLabelText
        case .basics:
            return OnboardingLocalization.introBasicsBodyLabelText
        }
    }
    
    /// Button text
    var buttonText: String {
        switch stage {
        case .aboutYou:
            return OnboardingLocalization.introAboutYouButtonText
        case .asksAndOffers:
            return OnboardingLocalization.introAsksOffersButtonLabelText
        case .basics:
            return OnboardingLocalization.introBasicsButtonText
        }
    }

}

// MARK: - AnalyticsIdentifiable
extension OnboardingStageIntroViewModel: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        switch stage {
        case .aboutYou:
            return AnalyticsScreen.onboardingAboutYouIntro.analyticsIdentifier
        case .asksAndOffers:
            return AnalyticsScreen.onboardingAsksOffersIntro.analyticsIdentifier
        case .basics:
            return AnalyticsScreen.onboardingBasicsIntro.analyticsIdentifier
        }
    }
    
}
