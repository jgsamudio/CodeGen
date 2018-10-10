//
//  PaginationInfo.swift
//  TheWing
//
//  Created by The Wing Developers on 06/08/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct PaginationInfo: Codable {
    
    // MARK: - Public Properties
    
	let hitsPerPage: Int
	let offset: Int // let offset: Bool
	let page: Int // let page: Bool
	let total: Int // let total: Int

	enum CodingKeys: String, CodingKey {
		case hitsPerPage = "hitsPerPage"
		case offset = "offset"
		case page = "page"
		case total = "total"
	}
}
