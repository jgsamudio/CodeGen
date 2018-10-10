//
//  GuestsInfo.swift
//  TheWing
//
//  Created by The Wing Developers on 06/13/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct GuestsInfo: Codable {
    
    // MARK: - Public Properties
    
	let guests: [Guest] // let guests: [Guest]
	let guestsCount: Int // let guestsCount: Bool

	enum CodingKeys: String, CodingKey {
		case guests = "guests"
		case guestsCount = "guestsCount"
	}
}
