//
//  KeyedDecodingContainer+CrossFit.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {

    /// Decodes a value of the given type for the given key. Allows string values to be parsed and translated directly to int.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decodeIfPresentAllowString(_ type: Int.Type, forKey key: K) throws -> Int? {
        let stringValue = (try? decode(String.self, forKey: key)).flatMap(Int.init)
        return try stringValue ?? decodeIfPresent(Int.self, forKey: key)
    }

    /// Decodes a value of the given type for the given key. Allows integer values to be parsed and translated directly to string.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decodeIfPresentAllowInt(_ type: String.Type, forKey key: K) throws -> String? {
        let intValue = (try? decode(Int.self, forKey: key)).flatMap(String.init)
        return try intValue ?? decodeIfPresent(String.self, forKey: key)
    }

    /// Decodes a value of the given type for the given key. Allows String values to be parsed and translated directly to Date.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func decodeIfPresentAllowDate(_ type: Date.Type, forKey key: K) throws -> Date? {
        let dateValue = try? decode(Date.self, forKey: key)
        return try dateValue ?? decodeIfPresent(String.self, forKey: key)
            .flatMap(CustomDateFormatter.apiDateFormatter.date)
    }

}
