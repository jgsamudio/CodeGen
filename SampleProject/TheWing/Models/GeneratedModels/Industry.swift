//
//  Industry.swift
//  TheWing
//
//  Created by The Wing Developers on 07/11/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Industry: Codable {
    
    // MARK: - Public Properties
    
	let industryId: String // let _id: String
	let name: String

	enum CodingKeys: String, CodingKey {
		case industryId = "_id"
		case name = "name"
	}
}
