//
//  UserDefaultsKeyConvertible.swift
//  TheWing
//
//  Created by Paul Jones on 9/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Your object can be converted into a user defaults key. See UserDefaultsExtensions.
protocol UserDefaultsKeyConvertible {
    
    /// The key.
    var userDefaultsKey: String { get }
    
}
