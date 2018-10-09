//
//  DateFormatter.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/29/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Date Formatters are expensive to create. In an effort to reduce overhead, static formatters are created per style.
struct CustomDateFormatter {

    /// Date Formatters for any birthdays
    static let birthDateFormatter: Foundation.DateFormatter = {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    /// Date Formatters for any medium formatting
    static let mediumDateFormatter: Foundation.DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()

    /// Date formatter for API responses such as start dates in leaderboard filters.
    static let apiDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss'+'zzzz"
        return dateFormatter
    }()

}
