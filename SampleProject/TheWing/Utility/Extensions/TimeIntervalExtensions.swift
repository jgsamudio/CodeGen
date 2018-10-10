//
//  TimeIntervalExtensions.swift
//  TheWing
//
//  Created by Jonathan Samudio on 8/31/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

extension TimeInterval {

    // MARK: - Public Functions
    
    /// Determines if the TimeInterval has passed from the given date.
    ///
    /// - Parameter date: Optional date to check.
    /// - Returns: Flag if the TimerInterval has passed from the given date.
    func hasElapsed(since date: Date?) -> Bool {
        if let date = date {
            return Date() > date + self
        }
        return false
    }

}
