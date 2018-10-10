//
//  TopMatches.swift
//  TheWing
//
//  Created by Ruchi Jain on 9/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct TopMatches: Codable {
    
    // MARK: - Public Properties
    
    let users: [Member]
    let total: Int
    
    enum CodingKeys: String, CodingKey {
        case users = "users"
        case total = "total"
    }
    
}
