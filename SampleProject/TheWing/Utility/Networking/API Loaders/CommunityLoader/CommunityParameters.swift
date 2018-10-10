//
//  CommunityParameters.swift
//  TheWing
//
//  Created by Ruchi Jain on 9/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Network parameters for the load members network call.
struct CommunityParameters {
    
    // MARK: - Public Properties
    
    /// Page offset.
    let page: Int
    
    /// Page size.
    let pageSize: Int
    
    /// Optional Filter parameters.
    let filters: FilterParameters?
    
    /// Optional search term.
    let term: String?
    
    /// Optional search criteria on which term is applied.
    let searchCriteria: String?

    /// Optional filter for matches only.
    let matchesOnly: Bool?
    
    /// Constant label for term query.
    static let termLabel = "term"
    
    /// Constant label for search criteria query.
    static let searchCriteriaLabel = "searchCriteria"
    
    /// Constant label for matches only query.
    static let matchesLabel = "matchesOnly"
    
}
