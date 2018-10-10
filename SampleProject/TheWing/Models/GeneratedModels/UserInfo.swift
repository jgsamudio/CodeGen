//
//  UserInfo.swift
//  TheWing
//
//  Created by The Wing Developers on 06/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct UserInfo: Codable {
    
    // MARK: - Public Properties
    
	let bookmarked: Bool
	let going: Bool
	let locked: Bool
	let waitlisted: Bool

	enum CodingKeys: String, CodingKey {
		case bookmarked = "bookmarked"
		case going = "going"
		case locked = "locked"
		case waitlisted = "waitlisted"
	}
}
