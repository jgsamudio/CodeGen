//
//  EventData.swift
//  TheWing
//
//  Created by Luna An on 5/10/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EventData: AnalyticsRepresentable {

    /// Id of the event.
    var eventId: String { get }
    
    /// Topic string.
    var topic: String { get }
    
    /// Topic icon url.
    var topicIconURL: URL? { get }
    
    /// Format type string.
    var format: String? { get }
    
    /// Guest per member.
    var guestPerMember: Int { get }
    
    /// Capacity.
    var capacity: Int { get }
    
    /// Available capacity.
    var availableCapacity: Int? { get }
    
    /// Available user guests.
    var availableUserGuests: Int { get }
    
    /// Guest capacity.
    var guestCapacity: Int? { get }
    
    /// Title of the event.
    var title: String { get }
    
    /// Location string of the event.
    var location: Location { get }
    
    /// Event day string.
    var day: String { get }
    
    /// Event time string.
    var time: String { get }
    
    /// Event fee string formatted.
    var feeString: String? { get }

    /// Amount of the fee.
    var feeAmount: Double? { get }
    
    /// Optional information detail string, e.g. Opens Soon.
    var infoDetail: String? { get }
    
    /// Determines if bookmark should appear.
    var bookmarkInfo: BookmarkInfo { get }
    
    /// Quick action associated with event.
    var quickAction: EventActionButtonSource? { get }
    
    /// More actions associated with event.
    var actions: [EventActionButtonSource] { get }
        
    // Start date of the event.
    var startDate: String { get }
    
    // End date of the event.
    var endDate: String? { get }
    
    /// Event description.
    var description: String { get }

    /// Member types for the event.
    var eventMemberTypes: [EventMemberType] { get }
    
    /// Event modal type for the associated modal.
    var eventModalType: EventModalType? { get }

    /// Indicates if the event is waitlisted.
    var hasWaitlist: Bool { get }
    
    /// Last event in the list.
    var isLastEvent: Bool { get }

    /// Optional array of guest data.
    var guestsData: [EventGuestRegistrationData]? { get }
    
    /// Boolean indicating that user has RSVP'd to an event.
    var going: Bool { get }
    
    /// Boolean indicating that user is waitlisted for an event.
    var waitlisted: Bool { get }
    
    /// Count of guest forms to display.
    var guestFormsCount: Int { get }
    
    /// Optional date on which event opens for rsvp.
    var rsvpOpenDate: Date? { get }
    
    /// Boolean determination of if event is open for rsvp or not.
    var openForRSVP: Bool { get }

    var analyticsProperties: [String: Any] { get }
}

extension EventData {

    // MARK: - Public Properties
    
    /// Name of the location.
    var locationName: String {
        return location.name
    }

    /// Formatted address for event detail view.
    var formattedAddress: String {
        guard let address = location.address else {
            return ""
        }
        let addressLineOne = address.addressOne.isEmpty ? "" : "\(address.addressOne) "
        let addressLineTwo = address.addressTwo.isEmpty ? "" : "\n\(address.addressTwo) "
        let cityLine = address.city.isEmpty ? "" : "\n\(address.city), "
        let stateLine = address.state.isEmpty ? "" : "\(address.state)"
        return "\(addressLineOne)\(addressLineTwo)\(cityLine)\(stateLine)"
    }

    /// Calendar info for the current event.
    var eventCalendarInfo: EventCalendarInfo? {
        guard let start = EventStringFormatter.date(for: startDate) else {
            return nil
        }

        var timeZone: TimeZone?
        if let timeZoneId = location.timeZoneId?.nilIfEmpty {
            timeZone = TimeZone(identifier: timeZoneId)
        }
        
        guard let endDate = endDate, !endDate.isEmpty, let end = EventStringFormatter.date(for: endDate) else {
            return EventCalendarInfo(title: title,
                                     notes: description,
                                     startDate: start,
                                     endDate: start.addingTimeInterval(BusinessConstants.defaultEventInterval),
                                     timeZone: timeZone ?? .current)
        }
        
        return EventCalendarInfo(title: title,
                                 notes: description,
                                 startDate: start,
                                 endDate: end,
                                 timeZone: timeZone ?? .current)
    }

    /// Determines if we should show the bookmark.
    var showBookmark: Bool {
        return actions.filter { $0.rsvpGoing || $0.isWaitlisted }.isEmpty
    }
    
    var quickAction: EventActionButtonSource? {
        return nil
    }
    
    var actions: [EventActionButtonSource] {
        return []
    }
    
    var eventModalType: EventModalType? {
        return nil
    }

    var isLastEvent: Bool {
        return false
    }

}
