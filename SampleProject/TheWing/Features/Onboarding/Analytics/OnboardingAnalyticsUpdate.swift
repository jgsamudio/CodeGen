//
//  OnboardingAnalyticsUpdate.swift
//  TheWing
//
//  Created by Paul Jones on 8/13/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Represents an update.
///
/// - none: No update.
/// - edited: Edit update.
/// - added: Add update.
/// - deleted: Delete update.
enum OnboardingAnalyticsUpdate: String {
    case none = "none"
    case edited = "edited"
    case added = "added"
    case deleted = "deleted"
    
    // MARK: - Public Functions
    
    /// Get a diff from initial and final onboarding social state
    ///
    /// - Parameters:
    ///   - initialSocialValues: the initial values of the social entry, be careful to avoid collision across services
    ///   - initialSocialFields: the initial fields of social entry
    ///   - finalSocialValues: the final social values, ex: facebook:username123
    ///   - finalSocialFields: the final social field, ex: facebook, twitter
    static func with(initialSocialValues: Set<String>,
                     initialSocialFields: Set<SocialType>,
                     finalSocialValues: Set<String>,
                     finalSocialFields: Set<SocialType>) -> OnboardingAnalyticsUpdate {
        if finalSocialFields.count > initialSocialFields.count {
            return .added
        } else if finalSocialFields.count < initialSocialFields.count {
            return .deleted
        } else if finalSocialValues == initialSocialValues {
            return .none
        } else {
            return .edited
        }
    }
    
    /// For the photo stage, pass in bools for had photo and changed photo.
    ///
    /// - Parameters:
    ///   - with: Did the user have a photo at the beginning? Or other Bool
    ///   - final: Did the user change the photo? Or other Bool
    static func with(initial: Bool, final: Bool) -> OnboardingAnalyticsUpdate {
        switch (initial, final) {
        case (false, true):
            return .added
        case (true, true):
            return .edited
        case (true, false):
            return .none
        case (false, false):
            return .none
        }
    }

    /// Gives you a diff on two occupation sets.
    ///
    /// - Parameters:
    ///   - initialOccupations: The initial set
    ///   - finalOccupations: The final set
    /// - Returns: Added, deleted, edited, or none.
    static func with(initialOccupations: Set<Occupation>, finalOccupations: Set<Occupation>) -> OnboardingAnalyticsUpdate {
        if initialOccupations.count < finalOccupations.count {
            return .added
        } else if initialOccupations.count > finalOccupations.count {
            return .deleted
        } else if initialOccupations != finalOccupations {
            return .edited
        } else {
            return .none
        }
    }
    
    /// Commpares two strings and gives you an analytics update.
    ///
    /// - Parameters:
    ///   - initial: First state
    ///   - final: Final state.
    /// - Returns: Added, deleted, edited, or none.
    static func with(initial: String?, final: String?) -> OnboardingAnalyticsUpdate {
        if initial?.nilIfEmpty == nil && final?.nilIfEmpty != nil {
            return .added
        } else if initial?.nilIfEmpty != nil && final?.nilIfEmpty == nil {
            return .deleted
        } else if initial?.nilIfEmpty != final?.nilIfEmpty {
            return .edited
        } else {
            return .none
        }
    }
    
    /// Takes two sets of indicies from tags and gives you an analytics diff.
    ///
    /// - Parameters:
    ///   - initialSelectedTagIndeces: Initial set
    ///   - finalSelectedTagIndeces: Final set
    /// - Returns: Added, deleted, edited, or none.
    static func with(initialSelectedTagIndeces: Set<Int>, finalSelectedTagIndeces: Set<Int>) -> OnboardingAnalyticsUpdate {
        if initialSelectedTagIndeces.count > finalSelectedTagIndeces.count {
            return .deleted
        } else if initialSelectedTagIndeces.count < finalSelectedTagIndeces.count {
            return .added
        } else if initialSelectedTagIndeces != finalSelectedTagIndeces {
            return .edited
        } else {
            return .none
        }
    }

}

// MARK: - AnalyticsIdentifiable
extension OnboardingAnalyticsUpdate: AnalyticsIdentifiable {
    
    // MARK: - Public Properties
    
    var analyticsIdentifier: String {
        return rawValue
    }
    
}
