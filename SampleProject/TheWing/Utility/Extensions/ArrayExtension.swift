//
//  ArrayExtension.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/10/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

extension Array {
    
    // MARK: - Public Properties
    
    /// Returns nil if array is empty.
    ///
    /// - Returns: Nil if empty, array otherwise.
    var nilIfEmpty: Array? {
        return isEmpty ? nil : self
    }
    
    // MARK: - Public Functions
    
    /// Removes item safely.
    ///
    /// - Parameter index: Index of the item to remove.
    mutating func removeSafely(at index: Int) {
        if index < count {
            remove(at: index)
        }
    }

}

extension Array where Element == Int {
    
    /// Returns the sum of elements in the array.
    ///
    /// - Returns: Sum of elements in array.
    func sum() -> Int {
        return reduce(0, +)
    }
    
}

// MARK: - Hashable
extension Array where Element: Hashable {
    
    /// Convinience for converting this array into a set.
    var set: Set<Element> {
        return Set<Element>(self)
    }
    
}

// MARK: - Comparable&Hashable
extension Array where Element: Comparable & Hashable {
    
    /// Does this array containt at least one duplicate?
    var containsDuplicates: Bool {
        return uniqueCount < count
    }
    
    /// Count of unique elements
    var uniqueCount: Int {
        return Array(set).count
    }

}

extension Array where Element == Bool {
    
    /// Returns true if all elements are true, false otherwise.
    ///
    /// - Parameter set: Whether all should be set to true or false.
    /// - Returns: True if all elements are true, false otherwise.
    func all(_ set: Bool) -> Bool {
        return !contains(!set)
    }
    
}

extension Array where Element == FormField {

    /// Closes the active form keyboard.
    func resignCurrentResponder() {
        forEach { $0.resignFirstResponder() }
    }

    ///  Sets the form delegate with the given parameter.
    ///
    /// - Parameter delegate: Delegate to set.
    mutating func setForm(delegate: FormDelegate) {
        for var field in self {
            field.formDelegate = delegate
        }
    }

}
