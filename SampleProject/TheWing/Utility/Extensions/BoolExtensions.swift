//
//  BoolExtensions.swift
//  TheWing
//
//  Created by Paul Jones on 8/22/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

extension Bool {
    
    // MARK: - Public Functions
    
    /// If this boolean is true, it will return you what you pass in, else nil.
    ///
    /// - Parameter any: Anything
    /// - Returns: Non-nil thing if true, nil if false
    func nilIfFalse<T>(_ any: T) -> T? {
        return self ? any : nil
    }
    
}
