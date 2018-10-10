//
//  SearchOccupationSection.swift
//  TheWing
//
//  Created by Luna An on 4/7/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Search occupation section types.
///
/// - searchResult: Search result table view section.
/// - userInput: User input table view section.
enum SearchOccupationSection: Int {
    case searchResult
    case userInput
    
    // MARK: - Public Properties
    
    /// All of the search occupation table view sections.
    static let allSections = [SearchOccupationSection.searchResult, .userInput]
}
