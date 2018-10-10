//
//  DateTimeConverter.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/29/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Date and time related functions
struct DateTime {

    // MARK: - Public Functions
    
    /// Converts a given time on specific time zone to string
    ///
    /// - Parameters:
    ///   - timeZone: Time zone abreviation
    ///   - time: Time in milliseconds
    ///   - format: Required format
    /// - Returns: Converted string
    static func convertToString(timeZone: String?,
                                date: Date, format: String) -> String {
    
    // MARK: - Public Properties
    
        let dateformatter = DateFormatter()
        dateformatter.amSymbol = "am"
        dateformatter.pmSymbol = "pm"
        if let timeZone = timeZone {
            dateformatter.timeZone = TimeZone(abbreviation: timeZone)
        } else if let currentTimeZone = getCurrentTimeZone() {
            dateformatter.timeZone = TimeZone(abbreviation: currentTimeZone)
        }

        dateformatter.dateFormat = format
        return dateformatter.string(from: date)
    }

    /// Returns the abbreviation of the current time zone
    ///
    /// - Returns: Current time zone abbreviation
    static func getCurrentTimeZone() -> String? {
        return TimeZone.current.abbreviation()
    }

}
