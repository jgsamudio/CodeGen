//
//  EventList.swift
//  TheWing
//
//  Created by The Wing Developers on 07/09/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct EventList: Codable {
    
    // MARK: - Public Properties
    
	let events: [Event]

	enum CodingKeys: String, CodingKey {
		case events = "events"
	}
}
