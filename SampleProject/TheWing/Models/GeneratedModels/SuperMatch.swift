//
//  SuperMatch.swift
//  TheWing
//
//  Created by The Wing Developers on 09/04/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct SuperMatch: Codable {
    
    // MARK: - Public Properties
    
	let matchEmoji: String? // let matchEmoji: String
	let matchString: String

	enum CodingKeys: String, CodingKey {
		case matchEmoji = "matchEmoji"
		case matchString = "matchString"
	}
}
