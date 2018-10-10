//
//  OffersList.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct OffersList: Codable {
    
    // MARK: - Public Properties
    
    let offers: [SearchResult]
    
    enum CodingKeys: String, CodingKey {
        case offers = "offers"
    }

}
