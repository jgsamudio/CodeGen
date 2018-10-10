//
//  AsksList.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct AsksList: Codable {
    
    // MARK: - Public Properties
    
    let asks: [SearchResult]
    
    enum CodingKeys: String, CodingKey {
        case asks = "asks"
    }

}
