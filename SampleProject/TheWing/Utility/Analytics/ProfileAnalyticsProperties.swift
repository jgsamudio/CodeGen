//
//  ProfileAnalyticsProperties.swift
//  TheWing
//
//  Created by Paul Jones on 8/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// An enum to represent all the profile analytics properties.
///
/// - numberOfOffers: How many offers are there?
/// - numberOfAsks: How many asks are there?
/// - photoFilled: Is the photo filled?
/// - headlineFilled: Is the headline filled?
/// - websiteFilled: Is the website filled?
/// - facebookFilled: Is the facebook filled?
/// - instagramFilled: Is the instagram filled?
/// - twitterFilled: Is the twitter filled?
/// - bioFilled: Is the bio filled?
/// - numberOfOccupations: How many occupations are there?
/// - industry: What's their industry?
/// - numberOfInterests: How many interests are there?
/// - neigbhorhoodFilled: Is the neighborhood filled?
/// - birthdayFilled: Is the birthday filled?
/// - starsignFilled: Is the starsign filled?
/// - profileCompleteScore: 0-18, based on the number of things filled out, non-nil, non-zero.
/// - occupations: What are their occupations?
enum ProfileAnalyticsProperties: String {
    case numberOfOffers = "Number of offers"
    case numberOfAsks = "Number of asks"
    case photoFilled = "Photo filled"
    case headlineFilled = "Headline filled"
    case websiteFilled = "Website filled"
    case facebookFilled = "Facebook filled"
    case instagramFilled = "Instagram filled"
    case twitterFilled = "Twitter filled"
    case bioFilled = "Bio filled"
    case numberOfOccupations = "Number of occupations"
    case industry = "Industry"
    case numberOfInterests = "Number of interests"
    case neigbhorhoodFilled = "Neighborhood filled"
    case birthdayFilled = "Birthday filled"
    case starsignFilled = "Star sign filled"
    case profileCompleteScore = "Profile complete score"
    case occupations = "Occupations"
}

// MARK: - AnalyticsIdentifiable
extension ProfileAnalyticsProperties: AnalyticsIdentifiable {
    
    // MARK: - Public Properties
    
    var analyticsIdentifier: String {
        return rawValue
    }
    
}
