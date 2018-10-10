//
//  OptionalType.swift
//  TheWing
//
//  Created by Paul Jones on 9/5/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Because of language limitations, namely type constraints in extensions, we must wrap
/// optional in a protocol so we can constraint Key and Value to optional using this
/// protocol instead of plain ol' Optional. Chris Lattner pls fix.
protocol OptionalType {
    associatedtype Wrapped
    var asOptional: Wrapped? { get }
}

// MARK: - OptionalType
extension Optional: OptionalType {
    
    // MARK: - Public Properties
    
    var asOptional: Wrapped? {
        return self
    }
    
}
