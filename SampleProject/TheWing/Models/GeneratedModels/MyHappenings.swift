//
//  MyHappenings.swift
//  TheWing
//
//  Created by The Wing Developers on 07/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct MyHappenings: Codable {
    
    // MARK: - Public Properties
    
	let bookmarks: Bookmarks
	let events: [Event]
	let totalCount: Int // let totalCount: Bool

	enum CodingKeys: String, CodingKey {
		case bookmarks = "bookmarks"
		case events = "events"
		case totalCount = "totalCount"
	}
}
