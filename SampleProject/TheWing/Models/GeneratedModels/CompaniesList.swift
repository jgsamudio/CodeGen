//
//  CompaniesList.swift
//  TheWing
//
//  Created by Luna An on 8/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct CompaniesList: Codable {
    
    // MARK: - Public Properties
    
    let companies: [SearchResult]
    
    enum CodingKeys: String, CodingKey {
        case companies = "companies"
    }
    
}
