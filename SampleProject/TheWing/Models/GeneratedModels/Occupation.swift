//
//  Occupation.swift
//  TheWing
//
//  Created by The Wing Developers on 07/06/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Occupation: Codable {
    
    // MARK: - Public Properties
    
	let company: String? // let company: String
	let occupationId: String? // let _id: String
	let position: String

	enum CodingKeys: String, CodingKey {
		case company = "company"
		case occupationId = "_id"
		case position = "position"
	}
}
