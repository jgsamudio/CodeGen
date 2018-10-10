//
//  EventLocalCache.swift
//  TheWing
//
//  Created by Jonathan Samudio on 7/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class EventLocalCache {
    
    // MARK: - Public Properties
    
    /// Cached event data.
    private(set) var data = [String: EventCacheData]()
    
    /// Total count of the rsvpd events.
    private(set) var totalCount = 0
    
    /// Total rsvpd bookmark count.
    private(set) var bookmarkTotalCount = 0
    
    // MARK: - Public Functions
    
    /// Called when events are loaded from the api.
    ///
    /// - Parameters:
    ///   - events: Array of events from the api.
    ///   - totalCount: Optional total count of all of the events.
    func cacheEventsFromApi(events: [Event], rsvpTotalCount: Int? = nil) {
        events.forEach {
            data[$0.eventId] = EventCacheData(userIsWaitlisted: $0.userInfo.waitlisted,
                                              userIsGoing: $0.userInfo.going,
                                              changedLocally: false,
                                              event: $0,
                                              bookmarkedInfo: ($0.userInfo.bookmarked, false))
        }
        
        if let totalCount = rsvpTotalCount {
            self.totalCount = totalCount
        }
    }
    
    /// Called when an user is confirmed that they are registered to an event.
    ///
    /// - Parameters:
    ///   - isWaitlisted: True, if registration is waitlist registration, false if rsvp.
    ///   - eventId: Event id of the registered event.
    func cacheRegisteredEvent(isWaitlisted: Bool, eventId: String) {
        totalCount += 1
        if let cachedEvent = data[eventId]?.event {
            bookmarkTotalCount -= cachedEvent.userInfo.bookmarked ? 1 : 0
            data[eventId] = EventCacheData(userIsWaitlisted: isWaitlisted,
                                           userIsGoing: !isWaitlisted,
                                           changedLocally: true,
                                           event: cachedEvent,
                                           bookmarkedInfo: (false, false))
        }
    }
    
    /// Called when an user is confirmed that they are cancelled.
    ///
    /// - Parameter eventId: Event id of the cancelled event.
    func cacheCancelledEvent(eventId: String) {
        totalCount -= 1
        if let cachedEvent = data[eventId]?.event {
            data[eventId] = EventCacheData(userIsWaitlisted: false,
                                           userIsGoing: false,
                                           changedLocally: true,
                                           event: cachedEvent,
                                           bookmarkedInfo: (false, false))
        }
    }
    
    /// Determines if the current user is going to the event.
    ///
    /// - Parameter eventId: Id of the event to check for.
    /// - Returns: Flag to determine if the user is going to the event.
    func userIsGoing(to eventId: String) -> Bool {
        return data[eventId]?.userIsGoing ?? false
    }
    
    /// Determines if the current user is waitlisted to the event.
    ///
    /// - Parameter eventId: Id of the event to check.
    /// - Returns: True, if user is waitlisted, false otherwise.
    func userIsWaitlisted(for eventId: String) -> Bool {
        return data[eventId]?.userIsWaitlisted ?? false
    }
    
    /// Determines if the event was changed locally.
    ///
    /// - Parameter eventId: Id of the event to check for.
    /// - Returns: A flag to determine if the event was changed locally.
    func eventChangedLocally(to eventId: String) -> Bool {
        return data[eventId]?.changedLocally ?? false
    }
    
    /// The next event that is not in the list provided.
    ///
    /// - Parameter events: Event list to check against for.
    /// - Returns: The first event that is not in the event list.
    func nextEvent(notFoundIn events: [Event]) -> Event? {
        let eventIds = events.map { $0.eventId }
        for cacheData in data {
            if !eventIds.contains(cacheData.value.event.eventId) && cacheData.value.userIsGoing {
                return cacheData.value.event
            }
        }
        return nil
    }
    
    /// Called when the user adds bookmark and before the network call.
    ///
    /// - Parameter eventId: Id of the event.
    func cacheAddBookmark(eventId: String) {
        bookmarkTotalCount += 1
        if let cachedEvent = data[eventId]?.event {
            data[eventId] = EventCacheData(userIsWaitlisted: false,
                                           userIsGoing: false,
                                           changedLocally: true,
                                           event: cachedEvent,
                                           bookmarkedInfo: (true, false))
        }
    }
    
    /// Called when the user removes bookmark and before the network call.
    ///
    /// - Parameter eventId: Id of the event.
    func cacheRemoveBookmark(eventId: String) {
        bookmarkTotalCount -= 1
        if let cachedEvent = data[eventId]?.event {
            data[eventId] = EventCacheData(userIsWaitlisted: false,
                                           userIsGoing: false,
                                           changedLocally: true,
                                           event: cachedEvent,
                                           bookmarkedInfo: (false, false))
        }
    }
    
    /// Cache the total bookmark count.
    ///
    /// - Parameter totalCount: Total bookmark count.
    func cacheBookmarkTotalCount(_ totalCount: Int) {
        bookmarkTotalCount = totalCount
    }
    
    /// Determines if the current event is bookmarked.
    ///
    /// - Parameter eventId: Event id to search with.
    /// - Returns: Flag if the event is bookmarked.
    func isBookmarked(eventId: String) -> Bool {
        return data[eventId]?.bookmarkedInfo.isBookmarked ?? false
    }
    
    /// Resets the event cache.
    func reset() {
        data = [String: EventCacheData]()
        totalCount = 0
        bookmarkTotalCount = 0
    }
    
}
