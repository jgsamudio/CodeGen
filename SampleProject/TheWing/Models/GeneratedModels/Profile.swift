//
//  Profile.swift
//  TheWing
//
//  Created by The Wing Developers on 08/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Profile: Codable {
    
    // MARK: - Public Properties
    
	let address: String? // let address: String
	let asks: [String]? // let asks: [String]
	let biography: String? // let bio: String
	let birthday: String? // let birthday: String
	let contactEmail: String? // let contact_email: String
	let facebook: String? // let facebook: String
	let headline: String? // let headline: String
	let industry: Industry? // let industry: Industry
	let instagram: String? // let instagram: String
	let interests: [String]? // let interests: [String]
	let name: Name
	let neighborhood: String? // let neighborhood: String
	let occupations: [Occupation]? // let occupations: [Occupation]
	let offers: [String]? // let offers: [String]
	let phone: String? // let phone: String
	let photo: String? // let photo: String
	let star: String? // let star: String
	let twitter: String? // let twitter: String
	let website: String? // let website: String

	enum CodingKeys: String, CodingKey {
		case address = "address"
		case asks = "asks"
		case biography = "bio"
		case birthday = "birthday"
		case contactEmail = "contact_email"
		case facebook = "facebook"
		case headline = "headline"
		case industry = "industry"
		case instagram = "instagram"
		case interests = "interests"
		case name = "name"
		case neighborhood = "neighborhood"
		case occupations = "occupations"
		case offers = "offers"
		case phone = "phone"
		case photo = "photo"
		case star = "star"
		case twitter = "twitter"
		case website = "website"
	}
}
