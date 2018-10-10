//
//  AttendeesInfo.swift
//  TheWing
//
//  Created by The Wing Developers on 06/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct AttendeesInfo: Codable {
    
    // MARK: - Public Properties
    
	let attendees: [Member]
	let attendeesCount: Int // let attendeesCount: Bool

	enum CodingKeys: String, CodingKey {
		case attendees = "attendees"
		case attendeesCount = "attendeesCount"
	}
}
