//
//  AttendeeList.swift
//  TheWing
//
//  Created by The Wing Developers on 07/09/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct AttendeeList: Codable {
    
    // MARK: - Public Properties
    
	let attendees: [Member] // let attendees: [Member]

	enum CodingKeys: String, CodingKey {
		case attendees = "attendees"
	}
}
