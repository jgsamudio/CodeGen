//
//  Guest.swift
//  TheWing
//
//  Created by The Wing Developers on 08/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Guest: Codable {
    
    // MARK: - Public Properties
    
	let email: String // let email: String
	let firstName: String // let firstName: String
	let lastName: String // let lastName: String
	let status: String? // let status: String

	enum CodingKeys: String, CodingKey {
		case email = "email"
		case firstName = "firstName"
		case lastName = "lastName"
		case status = "status"
	}
}
