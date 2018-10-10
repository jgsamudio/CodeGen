//
//  AnalyticsEvents.swift
//  TheWing
//
//  Created by Paul Jones on 8/31/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct AnalyticsEvents {
    
    enum Profile: String {
        
        case editButtonClicked = "My Profile Edit Button Clicked"
        
        case profileClicked = "My Profile Clicked"
        
        case profileSaved = "My Profile Saved Button Clicked"
        
        case editModeDismissed = "My Profile Edit Mode Dismissed"
        
    }
    
    enum Onboarding: String {
        
    // MARK: - Public Properties
    
        /// Was the step completed when the user landed on the screen?
        static let stepPreviouslyCompleted = "Step previously completed"
        
        /// Action user took on screen. Ex: none, edited, added, deleted
        static let stepUpdated = "Step updated"
        
        /// The name of the step
        static let stepName = "Step name"
        
        /// At start
        case started = "Onboarding Start Button Clicked"
        
        /// At end
        case completed = "Onboarding Complete Button Clicked"
        
        /// When step is complete
        case stepCompleted = "Onboarding Next Step Button Clicked"
        
        /// When step is viewed
        case stepViewed = "Onboarding Step Viewed"
        
    }
    
    enum Happenings: String {
        
        case rsvp = "Happening RSVP Button Clicked"
        
        case cancel = "Happening Cancel Button Clicked"
        
        case waitlist = "Happening Join Waitlist Button Clicked"
        
        case bookmark = "Happening Add Bookmark Clicked"
        
        case removeBookmark = "Happening Remove Bookmark Clicked"
        
        case cellTapped = "Happening Event Cell Clicked"
        
        case addedToCalendar = "Happening Added To Calendar"
        
        case editGuests = "Happening Add/Edit Guests Button Clicked"
        
        case saveGuests = "Happening Guests Save Button Clicked"
        
        case shareEvent = "Happening Share Button Clicked"
        
    }
    
    enum Community: String {
        
        case didSelectProfile = "Member Profile Clicked"
        
    }

}

// MARK: - AnalyticsIdentifiable
extension AnalyticsEvents.Profile: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return rawValue
    }
    
}

// MARK: - AnalyticsIdentifiable
extension AnalyticsEvents.Happenings: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return rawValue
    }
    
}

// MARK: - AnalyticsIdentifiable
extension AnalyticsEvents.Community: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return rawValue
    }
    
}

// MARK: - AnalyticsIdentifiable
extension AnalyticsEvents.Onboarding: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return rawValue
    }
    
}
