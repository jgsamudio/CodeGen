//
//  EventCalendarInfo.swift
//  TheWing
//
//  Created by Jonathan Samudio on 5/2/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class EventCalendarInfo {

    // MARK: - Public Properties

    /// Title of the event.
    let title: String

    /// Optional notes to add to the event.
    let notes: String?

    /// Start date of the event.
    let startDate: Date

    /// End date of the event.
    let endDate: Date
    
    /// Time zone of event.
    let timeZone: TimeZone
    
    // MARK: - Initialization
    
    init(title: String, notes: String?, startDate: Date, endDate: Date, timeZone: TimeZone) {
        self.title = title
        self.notes = notes
        self.startDate = startDate
        self.endDate = endDate
        self.timeZone = timeZone
    }
    
}
