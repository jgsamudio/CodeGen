//
//  ProfileExtension.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/11/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

extension Profile {
    
    // MARK: - Public Properties
    
    /// The URL of the photo for the user profile made out of the string for your convenience
    var photoUrl: URL? {
        return photo?.url
    }
    
    /// Count of offers
    var offersCount: Int {
        return offers.countOrZeroIfNil
    }

    /// Asks count
    var asksCounts: Int {
        return asks.countOrZeroIfNil
    }
    
    /// Did they enter a photo?
    var photoFilled: Bool {
        return (photo?.whitespaceTrimmed.nilIfEmpty) != nil
    }
    
    /// Did they enter a headline?
    var headlineFilled: Bool {
        return (headline?.whitespaceTrimmed.nilIfEmpty) != nil
    }

    /// Did they enter a website?
    var websiteFilled: Bool {
        return (website?.whitespaceTrimmed.nilIfEmpty) != nil
    }

    /// Did they enter a Facebook?
    var facebookFilled: Bool {
        return (facebook?.whitespaceTrimmed.nilIfEmpty) != nil
    }

    /// Did they enter a Instagram?
    var instagramFilled: Bool {
        return (instagram?.whitespaceTrimmed.nilIfEmpty) != nil
    }
    
    /// Did they enter a Twitter?
    var twitterFilled: Bool {
        return (twitter?.whitespaceTrimmed.nilIfEmpty) != nil
    }
    
    /// Did they enter a biography?
    var biographyFilled: Bool {
        return (biography?.whitespaceTrimmed.nilIfEmpty) != nil
    }
    
    /// Count of occupations
    var occupationCount: Int {
        return occupations.countOrZeroIfNil
    }
    
    // How to identify industry to analytics
    var industryAnalyticsIdentifier: String {
        return industry?.name ?? AnalyticsConstants.notFilledOut
    }
    
    var occupationsAnalyticsIdentifiers: [String] {
        return occupations?.map({$0.analyticsIdentifier}) ?? [AnalyticsConstants.notFilledOut]
    }
    
    /// Count of interests
    var interestsCount: Int {
        return interests.countOrZeroIfNil
    }
    
    /// Did they enter a neighborhood?
    var neighborhoodFilled: Bool {
        return (neighborhood?.whitespaceTrimmed.nilIfEmpty) != nil
    }
    
    /// Did they enter a birthday?
    var birthdayFilled: Bool {
        return (birthday?.whitespaceTrimmed.nilIfEmpty) != nil
    }
    
    /// Did they enter a star sign?
    var starsignFilled: Bool {
        return (star?.whitespaceTrimmed.nilIfEmpty) != nil
    }
    
    // 0-18 based on completedness
    var profileCompleteScore: Int {
        return [offersCount > 0,
                asksCounts > 0,
                photoFilled,
                headlineFilled,
                websiteFilled,
                facebookFilled,
                instagramFilled,
                twitterFilled,
                biographyFilled,
                occupationCount > 0,
                industry?.name != nil,
                interestsCount > 0,
                neighborhoodFilled,
                birthdayFilled,
                starsignFilled].filter({ $0 }).count
    }

}

// MARK: - AnalyticsRepresentable
extension Profile: AnalyticsRepresentable {
    
    var analyticsProperties: [String: Any] {
        let properties: [ProfileAnalyticsProperties: Any?] = [
            .numberOfOffers: offersCount,
            .numberOfAsks: asksCounts,
            .photoFilled: photoFilled,
            .headlineFilled: headlineFilled,
            .websiteFilled: websiteFilled,
            .facebookFilled: facebookFilled,
            .instagramFilled: instagramFilled,
            .twitterFilled: twitterFilled,
            .bioFilled: biographyFilled,
            .numberOfOccupations: occupationCount,
            .industry: industryAnalyticsIdentifier,
            .numberOfInterests: interestsCount,
            .neigbhorhoodFilled: neighborhoodFilled,
            .birthdayFilled: birthdayFilled,
            .starsignFilled: starsignFilled,
            .occupations: occupationsAnalyticsIdentifiers,
            .profileCompleteScore: profileCompleteScore
        ]
        return properties.analyticsRepresentation
    }
    
}

// MARK: - SocialLinkProvider
extension Profile: SocialLinkProvider {
    
}
