//
//  String+CrossFit.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/21/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

extension String {

    /// Returns the localized value of `self` as read from `Localization.strings`.
    var localized: String {
        return NSLocalizedString(self,
                                 tableName: "Localization",
                                 bundle: Bundle.main,
                                 comment: "")
    }

    /// Creates a random emoji to inform users feature is not fully complete
    ///
    /// - Returns: Random Emoji
    static func randomEmoji() -> String {
        let range: [UInt32] = Array(0x1F601...0x1F64F)
        let ascii = range[Int(arc4random_uniform(UInt32(range.count)))]
        return String(Character(UnicodeScalar(ascii) ?? UnicodeScalar(0)))
    }

    /// Compares two version strings
    ///
    /// - Parameters:
    ///   - version1: version string
    ///   - version2: version string which needs to be compared with
    /// - Returns: Int denoting (0 -> equals, -1 -> version1 > version2, 1 -> version1 < version2)
    static func compareVersions(version1: String, version2: String) -> ComparisonResult {
        var v1 = version1.components(separatedBy: ".").map { Int(String($0)) ?? 0 }
        var v2 = version2.components(separatedBy: ".").map { Int(String($0)) ?? 0 }
        var result = ComparisonResult.orderedSame
        for i in 0..<Swift.max(v1.count, v2.count) {
            let left = i >= v1.count ? 0 : v1[i]
            let right = i >= v2.count ? 0 : v2[i]

            if left == right {
                result = ComparisonResult.orderedSame
            } else if left > right {
                return ComparisonResult.orderedDescending
            } else if right > left {
                return ComparisonResult.orderedAscending
            }
        }
        return result
    }

    /// Converts a date string value to date based on the current time zone
    ///
    /// - Parameter format: format to expect
    /// - Returns: Converted date
    func toCurrentDate(dateFormatter formatter: DateFormatter) -> Date? {
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: self)
    }

}
