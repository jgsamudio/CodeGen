//
//  EditableProfile.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

struct EditableProfile {
    
    // MARK: - Public Properties

    var firstName: String?
    var lastName: String?
    var headline: String?
    var biography: String?
    var photo: String?
    var industry: Industry?
    var facebook: String?
    var instagram: String?
    var twitter: String?
    var website: String?
    var starSign: String?
    var neighborhood: String?
    var offers: [String]
    var asks: [String]
    var interests: [String]
    var occupations: [Occupation]?
    var birthday: Birthday?
    var contactEmail: String?

    /// Determines if first name is valid.
    var validFirstName: Bool {
        return firstName?.isValidString ?? false
    }
    
    /// Determines if last name is valid.
    var validLastName: Bool {
        return lastName?.isValidString ?? false
    }
    
    /// Determines if biography is valid.
    var validBiography: Bool {
        return biography?.isValidBio ?? true
    }
    
    /// Determines if industry is valid.
    var validIndustry: Bool {
        return industry != nil
    }
    
    /// Determines if occupations update is valid.
    var validOccupations: Bool {
        return !(occupations?.isEmpty ?? true)
    }
    
    /// Determines if visible email is valid.
    var validEmail: Bool {
        guard let email = contactEmail, !email.isEmpty else {
            return true
        }
        
        return email.isValidEmail
    }

    /// Determines if website is valid.
    var validWebsite: Bool {
        return (website?.isEmpty ?? true) || (website?.urlString.isValidUrl ?? true)
    }

    /// Determines if Facebook is valid.
    var validFacebook: Bool {
        return (facebook?.isEmpty ?? true) || (facebook?.isValidUrl ?? true) && (facebook?.isValidSocialLink ?? true)
    }
    
    /// Determines if Instagram is valid or not.
    var validInstagram: Bool {
        return (instagram?.isEmpty ?? true) || (instagram?.isValidUrl ?? true) && (instagram?.isValidHandle ?? true)
    }
    
    /// Determines if Twitter is valid or not.
    var validTwitter: Bool {
        return (twitter?.isEmpty ?? true) || (twitter?.isValidUrl ?? true) && (twitter?.isValidHandle ?? true)
    }
    
    /// Determines if the profile is valid for an update.
    var validUpdate: Bool {
        return validFirstName &&
            validLastName &&
            validBiography &&
            validIndustry &&
            validOccupations &&
            validEmail &&
            validWebsite &&
            validFacebook &&
            validInstagram &&
            validTwitter
    }
    
    /// Network parameters for updating the user object.
    var parameters: [String: Any] {
        var params = [String: Any]()

        params.insert(key: ProfileParameterKey.firstName.rawValue, object: firstName?.whitespaceTrimmed)
        params.insert(key: ProfileParameterKey.lastName.rawValue, object: lastName?.whitespaceTrimmed)
        params.insert(key: ProfileParameterKey.headline.rawValue, object: headline?.whitespaceTrimmed)
        params.insert(key: ProfileParameterKey.photo.rawValue, object: photo)
        params.insert(key: ProfileParameterKey.bio.rawValue, object: biography?.whitespaceTrimmed)
        params.insert(key: ProfileParameterKey.birthday.rawValue, object: birthday?.encodedBirthday ?? "")
        params.insert(key: ProfileParameterKey.website.rawValue, object: website?.whitespaceTrimmed)
        params.insert(key: ProfileParameterKey.industry.rawValue, object: industry?.parameters)
        params.insert(key: ProfileParameterKey.facebook.rawValue, object: facebook?.whitespaceTrimmed)
        params.insert(key: ProfileParameterKey.instagram.rawValue, object: instagram?.whitespaceTrimmed)
        params.insert(key: ProfileParameterKey.twitter.rawValue, object: twitter?.whitespaceTrimmed)
        params.insert(key: ProfileParameterKey.star.rawValue, object: starSign)
        params.insert(key: ProfileParameterKey.neighborhood.rawValue, object: neighborhood)
        params.insert(key: ProfileParameterKey.occupations.rawValue, object: occupations?.map { $0.parameters })
        params.insert(key: ProfileParameterKey.asks.rawValue, object: asks)
        params.insert(key: ProfileParameterKey.offers.rawValue, object: offers)
        params.insert(key: ProfileParameterKey.interests.rawValue, object: interests)
        params.insert(key: ProfileParameterKey.contactEmail.rawValue, object: contactEmail?.whitespaceTrimmed)

        return params
    }
    
    // MARK: - Initialization
    
    init(user: User) {
        firstName = user.profile.name.first.whitespaceTrimmed
        lastName = user.profile.name.last.whitespaceTrimmed
        headline = user.profile.headline?.whitespaceTrimmed
        photo = user.profile.photo
        biography = user.profile.biography?.whitespaceTrimmed
        industry = user.profile.industry
        facebook = user.profile.facebook?.whitespaceTrimmed
        instagram = user.profile.instagram?.whitespaceTrimmed
        twitter = user.profile.twitter?.whitespaceTrimmed
        website = user.profile.website?.whitespaceTrimmed
        neighborhood = user.profile.neighborhood
        starSign = user.profile.star
        interests = (user.profile.interests?.filter { !$0.whitespaceTrimmed.isEmpty })?.sorted() ?? []
        asks = (user.profile.asks?.filter { !$0.whitespaceTrimmed.isEmpty })?.sorted() ?? []
        offers = (user.profile.offers?.filter { !$0.whitespaceTrimmed.isEmpty })?.sorted() ?? []
        occupations = user.profile.occupations
        birthday = Birthday.decodeBirthday(birthday: user.profile.birthday)
        contactEmail = user.profile.contactEmail?.whitespaceTrimmed
    }

}

// MARK: - Equatable
extension EditableProfile: Equatable {
    
    // MARK: - Public Functions
    
    static func == (lhs: EditableProfile, rhs: EditableProfile) -> Bool {
        return lhs.firstName ?? "" == rhs.firstName ?? "" &&
        lhs.lastName ?? "" == rhs.lastName ?? "" &&
        lhs.headline ?? "" == rhs.headline ?? "" &&
        lhs.photo ?? "" == rhs.photo ?? "" &&
        lhs.birthday?.month ?? 0 == rhs.birthday?.month ?? 0 &&
        lhs.birthday?.day ?? 0 == rhs.birthday?.day ?? 0 &&
        lhs.biography ?? "" == rhs.biography ?? "" &&
        lhs.industry == rhs.industry &&
        lhs.facebook ?? "" == rhs.facebook ?? "" &&
        lhs.instagram ?? "" == rhs.instagram ?? "" &&
        lhs.twitter ?? "" == rhs.twitter ?? "" &&
        lhs.website ?? "" == rhs.website ?? "" &&
        lhs.starSign ?? "" == rhs.starSign ?? "" &&
        lhs.neighborhood ?? "" == rhs.neighborhood ?? "" &&
        lhs.interests == rhs.interests &&
        lhs.asks == rhs.asks &&
        lhs.offers == rhs.offers &&
        lhs.occupations ?? [] == rhs.occupations ?? [] &&
        lhs.contactEmail ?? "" == rhs.contactEmail ?? ""
    }
    
}

// MARK: - SocialLinkProvider
extension EditableProfile: SocialLinkProvider { }
