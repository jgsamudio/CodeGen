//
//  AnalyticsScreen.swift
//  TheWing
//
//  Created by Paul Jones on 8/31/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

enum AnalyticsScreen: String {
    
    case profile = "Profile"
    
    case home = "Home"
    
    case editProfile = "Edit Profile"
    
    case community = "Community"
    
    case topMatches = "Top Matches"
    
    case events = "Happenings"
    
    case members = "EDP See All Attendees"
    
    case eventDetail = "Event Details Page"
    
    case onboardingWelcome = "Welcome"
    
    case onboardingBasicsIntro = "Basics Intro"
    
    case onboardingPhoto = "Photo"
    
    case onboardingOccupation = "Occupation"
    
    case onboardingIndustry = "Industry"
    
    case onboardingSocial = "Social"
    
    case onboardingBasicsCompleted = "Basics Completed"
    
    case onboardingAboutYouIntro = "About You Intro"
    
    case onboardingInterests = "Interests"
    
    case onboardingNeighborhood = "Neighborhood"
    
    case onboardingBio = "Bio"
    
    case onboardingAboutYouCompleted = "About You Completed"
    
    case onboardingAsksOffersIntro = "Asks Offers Intro"
    
    case onboardingAsks = "Asks"
    
    case onboardingOffers = "Offers"
    
    case onboardingAsksOffersCompleted = "Asks Offers Completed"
    
    case onboardingProfile = "Onboarding Complete"
    
    case myEvents = "My Happenings"
    
    case editGuests = "Edit Guests"
    
}

// MARK: - AnalyticsIdentifiable
extension AnalyticsScreen: AnalyticsIdentifiable {
    
    // MARK: - Public Properties
    
    var analyticsIdentifier: String {
        return rawValue
    }
    
}
