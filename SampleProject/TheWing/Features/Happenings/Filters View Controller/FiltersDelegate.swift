//
//  FiltersDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol FiltersDelegate: class {
    
    /// Type of filter.
    var filterType: FilterType { get }
    
    /// Filter items loaded.
    var filterItemsDelegate: FilterItemsDelegate? { get set }
    
    /// Notifies delegate when filters were edited.
    ///
    /// - Parameters:
    ///   - filters: New filters.
    ///   - count: Count of the new filters.
    func editedFilters(_ filters: SectionedFilterParameters, count: Int)
    
    /// Loads the results count from applying selected filters.
    ///
    /// - Parameters:
    ///   - filters: Selected filters.
    ///   - completion: Completion handler containing count, or error.
    func loadResultsCount(filters: FilterParameters, completion: @escaping (_ count: Int?, _ error: Error?) -> Void)
    
}
