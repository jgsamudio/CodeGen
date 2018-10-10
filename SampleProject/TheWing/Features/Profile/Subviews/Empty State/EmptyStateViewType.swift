//
//  EmptyStateViewType.swift
//  TheWing
//
//  Created by Luna An on 4/13/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Profile empty state view types.
///
/// - bio: Bio type.
/// - industry: Industry type.
/// - offers: offers type.
/// - asks: Asks type.
/// - interests: Interests type.
/// - neighborhood: Neighborhood type.
/// - birthday: Birthday type.
/// - starSign: Star sign type.
/// - email: Email type.
enum EmptyStateViewType {
    case bio
    case industry
    case offers
    case asks
    case interests
    case neighborhood
    case birthday
    case starSign
    case email
    
    // MARK: - Public Properties
    
    /// Formatted title text of the type.
    var title: String? {
        switch self {
        case .bio:
            return "BIO".localized(comment: "Bio title")
        case .industry:
            return "INDUSTRY".localized(comment: "Industry title")
        case .offers:
            return "OFFERS".localized(comment: "Offers title")
        case .asks:
            return "ASKS".localized(comment: "Asks title")
        case .interests:
            return "INTERESTS".localized(comment: "Interests title")
        default:
            return nil
        }
    }
    
    /// Formatted description text of the type.
    var description: String? {
        switch self {
        case .bio:
            return "BIO_EMPTY_DESCRIPTION".localized(comment: "Empty bio description")
        case .industry:
            return "INDUSTRY_EMPTY_DESCRIPTION".localized(comment: "Empty industry description")
        case .offers:
            return "OFFERS_EMPTY_DESCRIPTION".localized(comment: "Empty offers description")
        case .asks:
            return "ASKS_EMPTY_DESCRIPTION".localized(comment: "Empty Asks description")
        case .interests:
            return "INTERESTS_DESCRIPTION".localized(comment: "Empty interests description")
        default:
            return nil
        }
    }
    
}

// MARK: - AnalyticsRepresentable
extension EmptyStateViewType: AnalyticsRepresentable {
    
    var analyticsProperties: [String: Any] {
        return [AnalyticsConstants.ProfileCTA.key: analyticsIdentifier]
    }
    
}

// MARK: - AnalyticsIdentifiable
extension EmptyStateViewType: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        let ctas = AnalyticsConstants.ProfileCTA.self
        switch self {
        case .bio:
            return ctas.bioEditButton.analyticsIdentifier
        case .industry:
            return ctas.industryEditButton.analyticsIdentifier
        case .offers:
            return ctas.offerEditButton.analyticsIdentifier
        case .asks:
            return ctas.askEditButton.analyticsIdentifier
        case .interests:
            return ctas.interestsEditButton.analyticsIdentifier
        case .neighborhood:
            return ctas.neighborhoodEditButton.analyticsIdentifier
        case .birthday:
            return ctas.birthdayEditButton.analyticsIdentifier
        case .starSign:
            return ctas.starSignEditButton.analyticsIdentifier
        case .email:
            return ctas.emailEditButton.analyticsIdentifier
        }
    }
    
}
