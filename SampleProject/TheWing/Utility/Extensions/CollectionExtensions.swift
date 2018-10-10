//
//  CollectionExtensions.swift
//  TheWing
//
//  Created by Paul Jones on 7/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

extension Collection {
    
    /// Returns an optional if the index is out of bounds.
    ///
    /// - Parameter index: What index of an item do you want to get?
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}

extension Collection where Element == String {
    
    // MARK: - Public Properties
    
    /// Gives you a human readable comma separated list
    var commaSeparated: String {
        return joined(separator: ", ")
    }
    
}
