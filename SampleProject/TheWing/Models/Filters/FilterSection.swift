//
//  FilterSection.swift
//  TheWing
//
//  Created by The Wing Developers on 05/11/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct FilterSection: Codable {
    
    // MARK: - Public Properties
    
	let filters: [Filter]
	let section: String

	enum CodingKeys: String, CodingKey {
		case filters = "filters"
		case section = "section"
	}
}
