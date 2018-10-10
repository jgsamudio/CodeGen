//
//  Pagination.swift
//  TheWing
//
//  Created by The Wing Developers on 07/09/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Pagination: Codable {
    
    // MARK: - Public Properties
    
	let hitsPerPage: Int
	let offset: Int // let offset: Bool
	let page: Int // let page: Bool
	let total: Int

	enum CodingKeys: String, CodingKey {
		case hitsPerPage = "hitsPerPage"
		case offset = "offset"
		case page = "page"
		case total = "total"
	}
}
