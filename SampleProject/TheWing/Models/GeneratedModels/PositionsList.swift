//
//  PositionsList.swift
//  TheWing
//
//  Created by Luna An on 8/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct PositionsList: Codable {
    
    // MARK: - Public Properties
    
    let positions: [SearchResult]
    
    enum CodingKeys: String, CodingKey {
        case positions = "positions"
    }
    
}
