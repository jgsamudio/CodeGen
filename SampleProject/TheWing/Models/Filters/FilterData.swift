//
//  FilterData.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct FilterData: Codable {
    
    // MARK: - Public Properties
    
    let options: [FilterSection]
    
    enum CodingKeys: String, CodingKey {
        case options = "options"
    }

}
