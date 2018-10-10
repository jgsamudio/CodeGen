//
//  EditGuestsResponse.swift
//  TheWing
//
//  Created by The Wing Developers on 06/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct EditGuestsResponse: Codable {
    
    // MARK: - Public Properties
    
	let eventMemberId: String
	let guests: [Guest]

	enum CodingKeys: String, CodingKey {
		case eventMemberId = "eventMemberId"
		case guests = "guests"
	}
}
