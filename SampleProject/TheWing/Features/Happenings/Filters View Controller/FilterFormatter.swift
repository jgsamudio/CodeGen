//
//  FilterFormatter.swift
//  TheWing
//
//  Created by Luna An on 6/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class FilterFormatter {
    
    // MARK: - Public Functions
    
    /// Formats filter parameters to send to API.
    ///
    /// - Parameter sectionedFilterParame: Sectioned filter parameters.
    /// - Returns: Formatted filter parameters.
    static func formatFilter(_ sectionedFilterParame: SectionedFilterParameters?) -> FilterParameters {
    
    // MARK: - Public Properties
    
        var formattedFilter = FilterParameters()
        for (key, value) in sectionedFilterParame ?? [:] {
            if !value.isEmpty {
                formattedFilter["\(key.lowercased())"] = value.map({ $0.filterId })
            }
        }
        
        return formattedFilter
    }
    
}
