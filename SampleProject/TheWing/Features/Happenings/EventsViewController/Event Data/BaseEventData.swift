//
//  BaseEventData.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Base event data used as a base class for the event cell data and event detail data.
class BaseEventData: AnalyticsRepresentable {

    // MARK: - Public Properties

    let eventId: String

    var topicIconURL: URL?
    
    let topic: String

    let format: String?

    let feeString: String?

    let feeAmount: Double?

    let title: String

    let location: Location

    let day: String

    let time: String
    
    let capacity: Int
    
    let hasWaitlist: Bool
    
    let availableCapacity: Int?
    
    let availableUserGuests: Int
    
    let guestCapacity: Int?
    
    let guestsInfo: GuestsInfo?
    
    let attendeesInfo: AttendeesInfo?

    let infoDetail: String?

    let bookmarkInfo: BookmarkInfo

    let startDate: String
    
    let endDate: String?

    let description: String

    let guestPerMember: Int

    let eventMemberTypes: [EventMemberType]

    let actions: [EventActionButtonSource]
    
    let guestsData: [EventGuestRegistrationData]?
    
    let going: Bool
    
    let waitlisted: Bool
    
    let guestFormsCount: Int
    
    let rsvpOpenDate: Date?
    
    let openForRSVP: Bool
    
    let analyticsProperties: [String: Any]

    // MARK: - Private Properties

    private let eventCache: EventLocalCache

    // MARK: - Initialization

    init(event: Event, bookmarkInfo: BookmarkInfo? = nil, eventCache: EventLocalCache) {
        self.eventCache = eventCache
        self.eventId = event.eventId
        self.analyticsProperties = event.analyticsProperties
        self.guestPerMember = event.guestPerMember ?? 0
        self.topic = event.topic.name
        self.format = event.format?.name
        self.topicIconURL = URL(string: event.topic.topicImage.png2x)
        self.feeString = EventStringFormatter.formatEventFee(event.fee)
        self.feeAmount = event.fee
        self.title = event.title
        self.location = event.location
        self.day = EventStringFormatter.formatDayDateString(event.startDateString, timeZoneId: event.location.timeZoneId)
        self.time = EventStringFormatter.formatTimeDuration(startDateString: event.startDateString,
                                                            endDateString: event.endDateString,
                                                            timeZoneId: event.location.timeZoneId)
        self.capacity = event.capacity ?? 0
        self.hasWaitlist = event.hasWaitlist
        self.availableCapacity = event.availableCapacity
        self.availableUserGuests = event.availableUserGuests ?? 0
        self.guestCapacity = event.guestCapacity
        self.guestsInfo = event.guestsInfo
        self.attendeesInfo = event.attendeesInfo
        self.infoDetail = event.infoDetail
        self.bookmarkInfo = bookmarkInfo ?? BookmarkInfo(event.userInfo.bookmarked, false)
        self.startDate = event.startDateString
        self.endDate = event.endDateString
        self.description = event.description
        self.eventMemberTypes = event.memberTypes
        self.actions = event.buttonActions(localBookmarked: bookmarkInfo?.isBookmarked, eventCache: eventCache)
        self.guestsData = event.registeredGuestData
        self.going = eventCache.userIsGoing(to: event.eventId)
        self.waitlisted = event.waitlisted
        self.guestFormsCount = event.guestFormsCount
        self.rsvpOpenDate = event.rsvpOpenDate
        self.openForRSVP = event.openForRSVP
    }

}
