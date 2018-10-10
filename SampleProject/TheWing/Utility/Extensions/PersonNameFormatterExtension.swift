//
//  PersonNameFormatterExtension.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/25/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

extension PersonNameComponentsFormatter {
    
    // MARK: - Public Functions
    
    /// Returns localized person name given name components.
    ///
    /// - Parameters:
    ///   - givenName: Given (or first) name.
    ///   - familyName: Family name (or surname).
    ///   - style: Person name components formatter style.
    /// - Returns: String form of name.
    static func nameString(givenName: String,
                           familyName: String,
                           style: PersonNameComponentsFormatter.Style = .default) -> String {
    
    // MARK: - Public Properties
    
        var components = PersonNameComponents()
        components.givenName = givenName
        components.familyName = familyName
        
        return PersonNameComponentsFormatter.localizedString(from: components, style: style, options: [])
    }
    
}
