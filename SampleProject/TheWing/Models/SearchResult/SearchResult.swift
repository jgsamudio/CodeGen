//
//  SearchResult.swift
//  TheWing
//
//  Created by The Wing Developers on 04/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

struct SearchResult: Codable {
    
    // MARK: - Public Properties
    
    let name: String
    let objectID: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case objectID = "objectID"
    }

}
