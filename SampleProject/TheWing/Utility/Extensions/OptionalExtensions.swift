//
//  OptionalStringExtensions.swift
//  TheWing
//
//  Created by Paul Jones on 8/22/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    
    // MARK: - Public Properties
    
    /// If this string is nil or empty, this returns false.
    var isEmptyOrNil: Bool {
        return self?.nilIfEmpty != nil
    }
    
    /// Is self nil? If so, get the empty string, otherwise get self.
    var emptyStringIfNil: String {
        return self ?? ""
    }
    
}

// MARK: - Collection
extension Optional where Wrapped: Collection {
    
    /// Gets the count or gives you zero if nil.
    var countOrZeroIfNil: Int {
        switch self {
        case .none:
            return 0
        case .some(let concreteSelf):
            return concreteSelf.count
        }
    }
    
}

// MARK: - Reachability
extension Optional where Wrapped: Reachability {
    
    var connected: Bool {
        if let shared = Reachability.shared {
            return shared.connection != .none
        } else {
            return false
        }
    }
    
}
