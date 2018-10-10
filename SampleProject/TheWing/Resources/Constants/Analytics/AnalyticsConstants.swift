//
//  AnalyticsConstants.swift
//  TheWing
//
//  Created by Luna An on 5/25/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct AnalyticsConstants {
    
    // MARK: - Shared
    
    // MARK: - Public Properties
    
    static let locationKey = "location"
    
    static let platformKey = "Platform"
    
    static let iOS = "iOS"
    
    static let emailKey = "email"
    
    static let screenName = "Screen name"
    
    // MARK: - Login
    
    static let loginEvent = "Account Logged In"
    
    static let usernameKey = "username"
    
    static let loginLocation = "Login"
    
    // MARK: - Reminders
    
    static let announcementsReminderKey = "Annoucements reminder"
    
    static let happeningsReminderKey = "Happenings reminder"
    
    static let notFilledOut = "Not filled out"
    
    enum ProfileCTA: String {
        
        static let key = "CTA type"
        
        case menuButton = "My Profile Menu Button"
        
        case memberCell = "Member Cell"
        
        case editButton = "Profile Edit Button"
        
        case checklistCard = "Checklist Card"
        
        case bioEditButton = "Bio Edit Button"
        
        case industryEditButton = "Industry Edit Button"
        
        case offerEditButton = "Offer Edit Button"
        
        case askEditButton = "Ask Edit Button"
        
        case interestsEditButton = "Interests Edit Button"
        
        case emailEditButton = "Email Edit Button"
        
        case neighborhoodEditButton = "Neighborhood Edit Button"
        
        case birthdayEditButton = "Birthday Edit Button"
        
        case starSignEditButton = "Star Sign Edit Button"
    }
    
    /// A container for the values.
    struct OnboardingValues {
        
        static let notApplicable = "NA"
        
    }

}

// MARK: - AnalyticsIdentifiable
extension AnalyticsConstants.ProfileCTA: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return rawValue
    }
    
}
