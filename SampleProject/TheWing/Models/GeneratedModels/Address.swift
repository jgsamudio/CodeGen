//
//  Address.swift
//  TheWing
//
//  Created by The Wing Developers on 07/09/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Address: Codable {
    
    // MARK: - Public Properties
    
	let addressOne: String
	let addressTwo: String
	let city: String
	let state: String
	let zip: Int? // let zip: Int

	enum CodingKeys: String, CodingKey {
		case addressOne = "addressOne"
		case addressTwo = "addressTwo"
		case city = "city"
		case state = "state"
		case zip = "zip"
	}
}
