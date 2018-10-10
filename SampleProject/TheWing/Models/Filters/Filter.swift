//
//  Filter.swift
//  TheWing
//
//  Created by The Wing Developers on 05/11/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Filter: Codable {
    
    // MARK: - Public Properties
    
	let filterId: String
	let name: String

	enum CodingKeys: String, CodingKey {
		case filterId = "_id"
		case name = "name"
	}
}

// MARK: - Equatable
extension Filter: Equatable {
    
    // MARK: - Public Functions
    
    static func == (lhs: Filter, rhs: Filter) -> Bool {
        return lhs.name == rhs.name && lhs.filterId == rhs.filterId
    }
    
}
