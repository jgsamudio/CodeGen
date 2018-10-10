//
//  DetailedUser.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/29/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Detailed information regarding user
struct DetailedUser: Codable {

    // MARK: - Public Properties
    
    /// Email
    let email: String

    /// Email verified
    let emailVerified: Bool

    /// Name
    let name: String

    /// Determines if journal subscription is enabled
    let journalSubscription: Bool

    /// Journal Payment Details
    let journalPayment: String?

    /// User Id
    let userId: String

    /// Formatted User Id
    let formattedUserId: String

    /// Birthday
    let birthday: Date?

    /// Address
    let address: String?

    /// City on address.
    let city: String?

    /// State (or region/province) on address.
    let state: String?

    /// Postal code on address.
    var postalCode: String?

    /// Country on address.
    let country: String?

    /// Phone
    let phone: String?

    /// Gender
    let gender: String

    /// No clue what this is
    let canRevalidateL1: Bool

    /// No clue what this is
    let canRetestL1: Bool

    private enum CodingKeys: String, CodingKey {
        case email
        case emailVerified = "email_verified"
        case name
        case journalSubscription
        case journalPayment
        case userId
        case formattedUserId
        case birthday
        case address
        case city
        case state
        case postalCode = "postal_code"
        case country
        case phone
        case gender
        case canRevalidateL1
        case canRetestL1
    }

    // MARK: - Initialization
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decode(String.self, forKey: .email)
        emailVerified = try values.decode(Bool.self, forKey: .emailVerified)
        name = try values.decode(String.self, forKey: .name)
        journalSubscription = try values.decode(Bool.self, forKey: .journalSubscription)
        journalPayment = try values.decodeIfPresent(String.self, forKey: .journalPayment)
        userId = try values.decode(String.self, forKey: .userId)
        formattedUserId = try values.decode(String.self, forKey: .formattedUserId)
        if let birthdayString = try values.decodeIfPresent(String.self, forKey: .birthday) {
            self.birthday = CustomDateFormatter.birthDateFormatter.date(from: birthdayString)
        } else {
            self.birthday = nil
        }
        address = try values.decodeIfPresent(String.self, forKey: .address)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        postalCode = try values.decodeIfPresent(String.self, forKey: .postalCode)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        gender = try values.decode(String.self, forKey: .gender)
        canRevalidateL1 = try values.decode(Bool.self, forKey: .canRevalidateL1)
        canRetestL1 = try values.decode(Bool.self, forKey: .canRetestL1)
    }

    // MARK: - Public Functions
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(email, forKey: .email)
        try container.encode(emailVerified, forKey: .emailVerified)
        try container.encode(name, forKey: .name)
        try container.encode(journalSubscription, forKey: .journalSubscription)
        try container.encodeIfPresent(journalPayment, forKey: .journalPayment)
        try container.encode(userId, forKey: .userId)
        try container.encode(formattedUserId, forKey: .formattedUserId)
        try container.encodeIfPresent(birthday.flatMap(CustomDateFormatter.birthDateFormatter.string), forKey: .birthday)
        try container.encodeIfPresent(address, forKey: .address)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(state, forKey: .state)
        try container.encodeIfPresent(postalCode, forKey: .postalCode)
        try container.encodeIfPresent(country, forKey: .country)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(gender, forKey: .gender)
        try container.encode(canRevalidateL1, forKey: .canRevalidateL1)
        try container.encode(canRetestL1, forKey: .canRetestL1)
    }

}
