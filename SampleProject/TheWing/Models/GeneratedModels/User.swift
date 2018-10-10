//
//  User.swift
//  TheWing
//
//  Created by The Wing Developers on 08/29/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct User: Codable {
    
    // MARK: - Public Properties
    
	let createdAt: String
	let location: Location? // let location: Location
	let onboardingAt: String
	let profile: Profile
	let startDate: String
	let userId: String // let _id: String

	enum CodingKeys: String, CodingKey {
		case createdAt = "createdAt"
		case location = "location"
		case onboardingAt = "onboardingAt"
		case profile = "profile"
		case startDate = "startDate"
		case userId = "_id"
	}
}
