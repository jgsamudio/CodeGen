//
//  EventExtension.swift
//  TheWing
//
//  Created by Jonathan Samudio on 5/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

extension Event {
    
    // MARK: - Public Properties
    
    /// Count of guest forms to display.
    var guestFormsCount: Int {
        if let guestsData = registeredGuestData, !guestsData.isEmpty {
            return min(guestPerMember ?? 0, availableUserGuests ?? 0 + guestsData.count)
        } else {
            return min(guestPerMember ?? 0, availableUserGuests ?? 0)
        }
    }
    
    /// Quick variable access to determine if user is RSVP'd to an event.
    var going: Bool {
        return userInfo.going
    }
    
    /// Quick variable access to determine if user is waitlisted to an event.
    var waitlisted: Bool {
        return userInfo.waitlisted
    }
    
    /// Registered guest data.
    var registeredGuestData: [EventGuestRegistrationData]? {
        return guestsInfo?.guests.compactMap {
            EventGuestRegistrationData(firstName: $0.firstName, lastName: $0.lastName, email: $0.email)
        }
    }
    
    /// Total count of registered event attendees.
    var attendeeCount: Int {
        return attendeesInfo?.attendeesCount ?? 0
    }
    
    /// Array of registered event attendees.
    var attendees: [Member] {
        return attendeesInfo?.attendees ?? []
    }

    /// Info detail of the event.
    var infoDetail: String? {
        return openForRSVP ? nil : "OPENS_SOON".localized(comment: "Opens soon")
    }

    /// Member types for the info view.
    var memberTypes: [EventMemberType] {
        var types = [EventMemberType]()

        if !openForRSVP {
            if let date = rsvpOpenDateString {
                let dateString = EventStringFormatter.formatDateString(date, timeZoneId: location.timeZoneId)
                types.append(EventMemberType.preview(date: dateString))
            } else {
                types.append(EventMemberType.preview(date: nil))
            }
        }
        
        if guestPerMember == 0 {
            types.append(.membersOnly)
        } else if (availableUserGuests ?? 0) > 0 {
            let guestType = EventMemberType.guest(numberOfGuests: guestPerMember ?? 0)
            types.append(guestType)
        }
        
        if let fee = fee, fee > 0 {
            types.append(EventMemberType.fee(amount: fee))
        }

        return types
    }
    
    /// Optional date on which rsvp will be open.
    var rsvpOpenDate: Date? {
        guard let rsvpOpenDateString = rsvpOpenDateString, !rsvpOpenDateString.isEmpty else {
            return nil
        }
        
        return EventStringFormatter.date(for: rsvpOpenDateString)
    }
    
    /// Start date of event.
    var startDate: Date? {
        return EventStringFormatter.date(for: startDateString)
    }
    
    /// End date of event.
    var endDate: Date? {
        return EventStringFormatter.date(for: endDateString ?? "")
    }
    
    /// Boolean determination if event is open for rsvp.
    var openForRSVP: Bool {
        guard let rsvpOpenDate = rsvpOpenDate else {
            return true
        }
        
        return Date() > rsvpOpenDate
    }

    // MARK: - Public Functions
    
    /// Quick action for the event cell view.
    ///
    /// - Parameter eventCache: Local event cache.
    /// - Returns: Event action button source.
    func quickAction(eventCache: EventLocalCache) -> EventActionButtonSource? {
        guard let startDate = startDate, startDate > Date() else {
            return nil
        }
        
        if userInfo.locked {
            return EventActionButtonSource.locked
        } else if !openForRSVP {
            return nil
        } else if eventCache.userIsGoing(to: eventId) {
            return EventActionButtonSource.rsvp(isGoing: true)
        } else if let waitlistAction = waitlistAction(eventCache: eventCache) {
            return waitlistAction
        } else {
            return EventActionButtonSource.rsvp(isGoing: false)
        }
    }

    /// EDP button actions.
    ///
    /// - Parameters:
    ///   - localBookmarked: Flag if the event is bookmarked locally.
    ///   - eventCache: Local event cache.
    /// - Returns: Array of event action button sources.
    func buttonActions(localBookmarked: Bool?, eventCache: EventLocalCache) -> [EventActionButtonSource] {
        guard let startDate = startDate, startDate > Date() else {
            return []
        }
        
        if let lockedAction = lockedAction() {
            return [lockedAction]
        } else if let bookmarkAction = bookmarkAction(localBookmarked: localBookmarked) {
            return [bookmarkAction]
        } else if let userActions = userIsGoingActions(eventCache: eventCache) {
            return userActions
        } else if let waitlistAction = waitlistAction(eventCache: eventCache) {
            return [waitlistAction]
        } else {
            return [EventActionButtonSource.rsvp(isGoing: false)]
        }
    }

}

// MARK: - Private Functions
private extension Event {
    
    func lockedAction() -> EventActionButtonSource? {
        guard userInfo.locked else {
            return nil
        }
        
        return EventActionButtonSource.locked
    }

    func bookmarkAction(localBookmarked: Bool?) -> EventActionButtonSource? {
        guard !openForRSVP else {
            return nil
        }
        
        return EventActionButtonSource.bookmark(isBookmarked: localBookmarked ?? false)
    }

    func waitlistAction(eventCache: EventLocalCache) -> EventActionButtonSource? {
        if eventCache.userIsWaitlisted(for: eventId) || userInfo.waitlisted {
            return EventActionButtonSource.waitlist(isWaitlisted: true)
        } else if hasWaitlist {
            return EventActionButtonSource.waitlist(isWaitlisted: false)
        } else {
            return nil
        }
    }
    
    func userIsGoingActions(eventCache: EventLocalCache) -> [EventActionButtonSource]? {
        guard eventCache.userIsGoing(to: eventId) else {
            return nil
        }
        var status = [EventActionButtonSource]()
        if let guestsCount = guestsInfo?.guestsCount, guestsCount > 0 {
            status.append(EventActionButtonSource.guest(attendingGuest: true))
        } else if availableUserGuests ?? 0 > 0, let guestPerMember = guestPerMember, guestPerMember > 0 {
            status.append(EventActionButtonSource.guest(attendingGuest: false))
        }
        status.append(EventActionButtonSource.rsvp(isGoing: userInfo.going))
        return status
    }

}

// MARK: - AnalyticsRepresentable
extension Event: AnalyticsRepresentable {
    
    var analyticsProperties: [String: Any] {
        let properties: [EventAnalyticsProperties: Any?] = [
            .eventId: eventId,
            .location: location.analyticsIdentifier,
            .topic: topic.analyticsIdentifier,
            .format: format?.analyticsIdentifier,
            .weekDay: startDate?.string(format: .weekDay),
            .startDate: startDate,
            .endDate: endDate,
            .guestsPerMember: guestPerMember,
            .fee: fee,
            .attendeesCount: attendeeCount,
            .rsvpStatus: userInfo.analyticsIdentifier,
            .rsvpOpenStatus: openForRSVP,
            .guestWithMemberCount: registeredGuestData.countOrZeroIfNil
        ]
        return properties.analyticsRepresentation
    }
    
}
