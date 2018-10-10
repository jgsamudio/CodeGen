//
//  Name.swift
//  TheWing
//
//  Created by The Wing Developers on 04/06/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Name: Codable {
    
    // MARK: - Public Properties
    
	let first: String
	let last: String

	enum CodingKeys: String, CodingKey {
		case first = "first"
		case last = "last"
	}
}
