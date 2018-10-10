//
//  Format.swift
//  TheWing
//
//  Created by The Wing Developers on 06/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Format: Codable {
    
    // MARK: - Public Properties
    
	let formatId: String // let _id: String
	let name: String

	enum CodingKeys: String, CodingKey {
		case formatId = "_id"
		case name = "name"
	}
}
