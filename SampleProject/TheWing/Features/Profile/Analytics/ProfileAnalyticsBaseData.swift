//
//  ProfileAnalyticsBaseData.swift
//  TheWing
//
//  Created by Luna An on 6/19/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class ProfileAnalyticsBaseData {

    // MARK: - Public Properties
    
    /// Indicates if profile photo is filled.
    var imageURLFilled = false {
        didSet {
            configureFields(filled: imageURLFilled, field: ProfileField.photo.title)
        }
    }
    
    /// Indicates if headline is filled.
    var headlineFilled = false {
        didSet {
            configureFields(filled: headlineFilled, field: ProfileField.headline.title)
        }
    }
    
    /// Indicates if biography is filled.
    var bioFilled = false {
        didSet {
            configureFields(filled: bioFilled, field: ProfileField.bio.title)
        }
    }
    
    /// Indicates if industry is filled.
    var industryFilled = false {
        didSet {
            configureFields(filled: industryFilled, field: ProfileField.industry.title)
        }
    }
    
    /// Indicates if website is filled.
    var websiteFilled = false {
        didSet {
            configureFields(filled: websiteFilled, field: ProfileField.website.title)
        }
    }
    
    /// Indicates if facebook is filled.
    var facebookFilled = false {
        didSet {
            configureFields(filled: facebookFilled, field: ProfileField.facebook.title)
        }
    }
    
    /// Indicates if instagram is filled.
    var instagramFilled = false {
        didSet {
            configureFields(filled: instagramFilled, field: ProfileField.instagram.title)
        }
    }
    
    /// Indicates if twitter is filled.
    var twitterFilled = false {
        didSet {
            configureFields(filled: twitterFilled, field: ProfileField.twitter.title)
        }
    }
    
    /// Indicates if occupation is filled.
    var occupationsFilled = false {
        didSet {
            configureFields(filled: occupationsFilled, field: ProfileField.occupations.title)
        }
    }
    
    /// Indicates if offers field is filled.
    var offersFilled = false {
        didSet {
            configureFields(filled: offersFilled, field: ProfileField.offers.title)
        }
    }
    
    /// Indicates if asks field is filled.
    var asksFilled = false {
        didSet {
            configureFields(filled: asksFilled, field: ProfileField.asks.title)
        }
    }
    
    /// Indicates if interests field is filled.
    var interestsFilled = false {
        didSet {
            configureFields(filled: interestsFilled, field: ProfileField.interests.title)
        }
    }
    
    /// Indicates if neighborhood is filled.
    var neighborhoodFilled = false {
        didSet {
            configureFields(filled: neighborhoodFilled, field: ProfileField.neighborhood.title)
        }
    }
    
    /// Indicates if star sign is filled.
    var starSignFilled = false {
        didSet {
            configureFields(filled: starSignFilled, field: ProfileField.starsign.title)
        }
    }
    
    /// Indicates if joined date is filled.
    var joinedDateFilled = false {
        didSet {
            configureFields(filled: joinedDateFilled, field: ProfileField.joineddate.title)
        }
    }
    
    /// Indicates the number of occupations user has filled.
    var numberOfOccupations = 0
    
    /// Indicates the number of offers user has filled.
    var numberOfOffers = 0
    
    /// Indicates the number of asks user has filled.
    var numberOfAsks = 0
    
    /// Indicates the number of interests user has filled.
    var numberOfInterests = 0
    
    /// Indiacates completed fields.
    var completedFields: Set<String> = []
    
    /// Indiacates incomplete fields.
    var incompleteFields: Set<String> = []
    
    // MARK: - Public Functions
    
    /// Resets counts.
    func resetCounts() {
        numberOfOccupations = 0
        numberOfOffers = 0
        numberOfAsks = 0
        numberOfInterests = 0
    }
    
}

// MARK: - Private Functions
private extension ProfileAnalyticsBaseData {
    
    func configureFields(filled: Bool, field: String) {
        if filled {
            completedFields.insert(field)
            incompleteFields.remove(field)
        } else {
            incompleteFields.insert(field)
            completedFields.remove(field)
        }
    }
    
}
