//
//  Response.swift
//  TheWing
//
//  Created by The Wing Developers on 08/01/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Response: Codable {
    
    // MARK: - Public Properties
    
	let announcements: [Announcement]? // let announcements: [Announcement]
	let myHappenings: MyHappenings? // let myHappenings: MyHappenings
	let myToDos: [Task]? // let myToDos: [Task]

	enum CodingKeys: String, CodingKey {
		case announcements = "announcements"
		case myHappenings = "myHappenings"
		case myToDos = "myToDos"
	}
}
