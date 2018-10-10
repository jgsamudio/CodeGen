//
//  DatePicker.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/3/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Date picker which can be used to set a globally valid date for test purposes (unless in release config).
final class DatePicker {

    #if DEBUG || ALPHA || BETA
    
    // MARK: - Public Properties
    
    var dateValue = Date()
    #endif

    /// Date that was set in the date picker.
    var date: Date {
        get {
            #if DEBUG || ALPHA || BETA
            return dateValue
            #else
            return Date()
            #endif
        }
        set {
            #if DEBUG || ALPHA || BETA
            dateValue = newValue
            NotificationCenter.default.post(name: NotificationName.yoshiDatePickerUpdated.name, object: self, userInfo: nil)
            #endif
        }
    }

    /// Shared date picker instance.
    static let shared = DatePicker()

}
