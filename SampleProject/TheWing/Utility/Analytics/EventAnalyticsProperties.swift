//
//  EventAnalyticsProperties.swift
//  TheWing
//
//  Created by Paul Jones on 8/31/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Analytics properties for events.
///
/// - eventId: database ID for this event
/// - location: Wing location for this event
/// - topic: topic of this event
/// - format: format of this event
/// - weekDay: day of the week of this event
/// - startDate: start time and date of event
/// - endDate: end time and date of event
/// - guestsPerMember: number of guests allowed per member for this event
/// - fee: fee for this event
/// - attendeesCount: number of total attendees attending this event (members)
/// - rsvpStatus: When the user performed the action, what was their status in relation to the event
/// - guestWithMemberCount: When the user performed the action, how many guests registered for the event
/// - rsvpOpenStatus: At the time of the event, was the event open for RSVP
enum EventAnalyticsProperties: String {
    case eventId = "Happening ID"
    case location = "Happening location"
    case topic = "Topic"
    case format = "Format"
    case weekDay = "Day of the week"
    case startDate = "Start date"
    case endDate = "End date"
    case guestsPerMember = "Guests per member allowed"
    case fee = "Fee"
    case attendeesCount = "Current number of attendees"
    case rsvpStatus = "User's RSVP status"
    case guestWithMemberCount = "Number of guests going with member"
    case rsvpOpenStatus = "RSVP Open Status"
}

// MARK: - AnalyticsIdentifiable
extension EventAnalyticsProperties: AnalyticsIdentifiable {
    
    // MARK: - Public Properties
    
    var analyticsIdentifier: String {
        return rawValue
    }
    
}
