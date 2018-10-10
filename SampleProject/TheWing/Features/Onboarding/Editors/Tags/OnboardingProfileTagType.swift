//
//  OnboardingProfileTagType.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Tag type in the onboarding flow.
///
/// - asks: Asks.
/// - offers: Offers.
/// - interests: Interests.
enum OnboardingProfileTagType {
    case asks(selected: Bool)
    case offers(selected: Bool)
    case interests(selected: Bool)

    // MARK: - Public Properties
    
    /// Default list of tags to display.
    var defaults: [String] {
        switch self {
        case .asks, .offers:
            return ["Mentorship",
                    "Friendship",
                    "Travel Buddy",
                    "Social Media 101s",
                    "Resume Advice",
                    "Interview Prep",
                    "Workout Buddy",
                    "Event Planning",
                    "Legal Advice",
                    "Brand Strategy",
                    "Babysitting",
                    "Web Design"]
        case .interests:
            return ["Travel",
                    "Writing",
                    "Fashion",
                    "Books",
                    "Art",
                    "Yoga",
                    "Politics",
                    "Music",
                    "Food",
                    "Reading",
                    "Wine",
                    "Film"]
        }
    }
    
    /// Parameter key associated with tag type.
    var parameterKey: String {
        switch self {
        case .asks:
            return ProfileParameterKey.asks.rawValue
        case .offers:
            return ProfileParameterKey.offers.rawValue
        case .interests:
            return ProfileParameterKey.interests.rawValue
        }
    }

}

// MARK: - TagViewDataSource
extension OnboardingProfileTagType: TagViewDataSource {
    
    var isRemovable: Bool {
        return false
    }
    
    var isSelectable: Bool {
        return !selected
    }
    
    var selected: Bool {
        switch self {
        case .asks(let selected):
            return selected
        case .offers(let selected):
            return selected
        case .interests(let selected):
            return selected
        }
    }
    
    // MARK: - Public Functions
    
    func cellBackgroundColor(theme: Theme) -> UIColor {
        return selected ? theme.colorTheme.primary : UIColor.clear
    }
    
}
