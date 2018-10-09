//
//  TimeIntervalFormatter.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/19/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Formatter for time intervals, such as ss, mm:ss, mm:ss.sss, HH:mm:ss.sss etc. (colon separated).
final class TimeIntervalFormatter: NumberFormatter {

    // MARK: - Public Functions
    
    override func number(from string: String) -> NSNumber? {
        guard !string.isEmpty else {
            return 0
        }

    // MARK: - Public Properties
    
        var interval: Double = 0

        let parts = string.components(separatedBy: ":")
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }

        return NSNumber(value: interval)
    }

}
