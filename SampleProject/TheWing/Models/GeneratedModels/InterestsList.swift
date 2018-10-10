//
//  InterestsList.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct InterestsList: Codable {
    
    // MARK: - Public Properties
    
    let interests: [SearchResult]
    
    enum CodingKeys: String, CodingKey {
        case interests = "interests"
    }

}
