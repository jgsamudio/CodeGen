//
//  DateExtension.swift
//  TheWing
//
//  Created by Ruchi Jain on 7/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

extension Date {
    
    // MARK: - Public Functions
    
    /// Gets you the string from date format
    ///
    /// - Parameter format: See DateFormat enum
    /// - Returns: A string if possible
    func string(format: DateFormat) -> String? {
        return DateFormatter.string(of: self, using: format)
    }
    
    /// Returns formatted string that sensibly describes time since given date.
    ///
    /// - Parameter date: Date
    /// - Returns: Time since date in either minutes, hours, days, weeks, and months.
    static func timeSinceString(from date: Date) -> String {
        if minutesSince(date: date) <= 60 {
            if minutesSince(date: date) > 1 {
                return String(format: "MINUTES_AGO".localized(comment: "n Minutes Ago"), "\(minutesSince(date: date))")
            } else {
                return "MINUTE_AGO".localized(comment: "A minute ago")
            }
        } else if hoursSince(date: date) <= 24 {
            if hoursSince(date: date) > 1 {
                return String(format: "HOURS_AGO".localized(comment: "n Hours Ago"), "\(hoursSince(date: date))")
            } else {
                return "HOUR_AGO".localized(comment: "An hour ago")
            }
        } else if daysSince(date: date) <= 7 {
            if daysSince(date: date) > 1 {
                return String(format: "DAYS_AGO".localized(comment: "n Days Ago"), "\(daysSince(date: date))")
            } else {
                return "DAY_AGO".localized(comment: "Yesterday")
            }
        } else if weeksSince(date: date) <= 4 {
            if weeksSince(date: date) > 1 {
                return String(format: "WEEKS_AGO".localized(comment: "n Weeks Ago"), "\(weeksSince(date: date))")
            } else {
                return "WEEK_AGO".localized(comment: "Last week")
            }
        } else if monthsSince(date: date) <= 1 {
            return "MONTH_AGO".localized(comment: "Last month")
        } else {
            return String(format: "MONTHS_AGO".localized(comment: "n Months Ago"), "\(monthsSince(date: date))")
        }
    }
    
    /// Returns days for month.
    ///
    /// - Parameter month: Month to get days from.
    /// - Returns: Days array.
    static func days(for month: Int?) -> [Int] {
    
    // MARK: - Public Properties
    
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = 2016 // Default year to get days in leap years
        dateComponents.month = month ?? 0
        
        guard let date = calendar.date(from: dateComponents),
            let daysRange = calendar.range(of: .day, in: .month, for: date) else {
                return []
        }
        
        return Array(1..<daysRange.upperBound)
    }

    /// Get the number of weeks since a date in an Int
    ///
    /// - Parameter date: The date you're comparing yours to to get number of weeks
    /// - Returns: The number of weeks
    static func weeksSince(date: Date) -> Int {
        return Int(Date().timeIntervalSince(date) / 604800)
    }

    /// Get the numver of days since a date in an Int
    ///
    /// - Parameter date: The date you're comparing yours to to get number of weeks
    /// - Returns: The number of days
    static func daysSince(date: Date) -> Int {
        return Int(Date().timeIntervalSince(date) / 86400)
    }

}

// MARK: - Private Functions
private extension Date {
    
    static func minutesSince(date: Date) -> Int {
        return Int(Date().timeIntervalSince(date) / 60)
    }
    
    static func hoursSince(date: Date) -> Int {
        return Int(Date().timeIntervalSince(date) / 3600)
    }
    
    static func monthsSince(date: Date) -> Int {
        return Int(Date().timeIntervalSince(date) / 2419200)
    }
    
}
