//
//  ProfileFields.swift
//  TheWing
//
//  Created by Luna An on 6/13/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Profile fields.
///
/// - photo: Photo.
/// - headline: Headline.
/// - bio: Biography.
/// - industry: Industry.
/// - website: Website.
/// - facebook: Facebook.
/// - instagram: Instagram
/// - twitter: Twitter.
/// - occupations: Occupations.
/// - offers: Offers.
/// - asks: Asks.
/// - interests: Interests.
/// - neighborhood: Neighborhood.
/// - starsign: Star sign.
/// - joineddate: Joined date.
enum ProfileField {
    case photo
    case headline
    case bio
    case industry
    case website
    case facebook
    case instagram
    case twitter
    case occupations
    case offers
    case asks
    case interests
    case neighborhood
    case starsign
    case joineddate
    
    // MARK: - Public Properties
    
    /// Field title.
    var title: String {
        switch self {
        case .photo:
            return AnalyticsProfileConstants.profilePhoto
        case .headline:
            return AnalyticsProfileConstants.profileHeadline
        case .bio:
            return AnalyticsProfileConstants.profileBio
        case .industry:
            return AnalyticsProfileConstants.profileIndustry
        case .website:
            return AnalyticsProfileConstants.profileSocialWebsite
        case .facebook:
            return AnalyticsProfileConstants.profileSocialFacebook
        case .instagram:
            return AnalyticsProfileConstants.profileSocialInstagram
        case .twitter:
            return AnalyticsProfileConstants.profileSocialTwitter
        case .occupations:
            return AnalyticsProfileConstants.profileOccupations
        case .offers:
            return AnalyticsProfileConstants.profileOffers
        case .asks:
            return AnalyticsProfileConstants.profileAsks
        case .interests:
            return AnalyticsProfileConstants.profileInterests
        case .neighborhood:
            return AnalyticsProfileConstants.profileNeighborhood
        case .starsign:
            return AnalyticsProfileConstants.profileStarsign
        case .joineddate:
            return AnalyticsProfileConstants.memberJoinedDate
        }
    }
    
    /// All fields as set
    static var all: Set<ProfileField> = [
        .asks,
        .bio,
        .facebook,
        .industry,
        .instagram,
        .interests,
        .neighborhood,
        .occupations,
        .offers,
        .photo,
        .twitter,
        .website,
        .starsign,
        .headline
    ].set
    
}

// MARK: - AnalyticsIdentifiable
extension ProfileField: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return title
    }
    
}
