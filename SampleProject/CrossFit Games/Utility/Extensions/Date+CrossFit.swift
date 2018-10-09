//
//  Date+CrossFit.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/30/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

extension Date {

    /// Initializes a date with `CrossFit standard time` (i.e. Pacific standard time) in seconds since 1970.
    ///
    /// - Parameter crossFitStandardTime: Date in pacific standard time.
    init(crossFitStandardTime: Int, timeZone: String = "PST") {
        let dateformatter = DateFormatter()
        dateformatter.timeStyle = .medium
        dateformatter.dateStyle = .medium
        dateformatter.timeZone = TimeZone(abbreviation: timeZone)

        let currentTime = Date(timeIntervalSince1970: TimeInterval(crossFitStandardTime))

        if let localTime = dateformatter.date(from: dateformatter.string(from: currentTime)) {
            self = localTime
        } else {
            self = Date(timeIntervalSince1970: TimeInterval(crossFitStandardTime))
        }
    }

}
