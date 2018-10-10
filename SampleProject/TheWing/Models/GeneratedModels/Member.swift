//
//  Member.swift
//  TheWing
//
//  Created by The Wing Developers on 09/04/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Member: Codable {
    
    // MARK: - Public Properties
    
	let asks: [String]?
	let avatar: String // let profilePhoto: String
	let birthday: String?
	let facebook: String? // let facebook: String?
	let firstName: String
	let headline: String? // let headline: String
	let industry: Industry?
	let instagram: String? // let instagram: String?
	let lastName: String
	let location: Location?
	let memberId: String
	let offers: [String]?
	let superMatch: SuperMatch?
	let twitter: String? // let twitter: String?
	let website: String? // let website: String?

	enum CodingKeys: String, CodingKey {
		case asks = "asks"
		case avatar = "profilePhoto"
		case birthday = "birthday"
		case facebook = "facebook"
		case firstName = "firstName"
		case headline = "headline"
		case industry = "industry"
		case instagram = "instagram"
		case lastName = "lastName"
		case location = "location"
		case memberId = "memberId"
		case offers = "offers"
		case superMatch = "superMatch"
		case twitter = "twitter"
		case website = "website"
	}
}
