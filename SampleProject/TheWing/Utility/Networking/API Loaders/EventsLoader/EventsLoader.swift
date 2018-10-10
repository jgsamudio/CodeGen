//
//  EventsLoader.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/31/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Alamofire

protocol EventsLoader {
    
    /// Loads events list from API given page, page size, and filter parameters.
    ///
    /// - Parameters:
    ///   - parameters: Parameters for the network call.
    ///   - completion: Completion handler with event list.
    func loadEvents(parameters: EventsParameters,
                    completion: @escaping (_ result: Result<ResponseData<EventList>>) -> Void)
    
    /// Loads an event with the given parameters.
    ///
    /// - Parameters:
    ///   - eventId: Id of the event to load.
    ///   - membersLimit: Number of attendees to be returned.
    ///   - completion: Completion handler with the desired event.
    func loadEvent(eventId: String, membersLimit: Int, completion: @escaping (_ result: Result<ResponseData<Event>>) -> Void)
    
    /// Loads filter options.
    ///
    /// - Parameter completion: Completion handler with array of filter sections.
    func loadFilterSections(completion: @escaping (_ result: Result<ResponseData<FilterData>>) -> Void)
    
    /// Loads the registration for the given event.
    ///
    /// - Parameters:
    ///   - eventId: Event id of the current event.
    ///   - completion: Completion handler with the event registration info.
    func register(eventId: String, completion: @escaping (_ result: Result<ResponseData<Event>>) -> Void)

    /// Cancel's a user's rsvp.
    ///
    /// - Parameters:
    ///   - eventId: Event id of the current event
    ///   - completion: Completion handler with a success response.
    func cancel(eventId: String, completion: @escaping (_ result: Result<ResponseData<Event>>) -> Void)
    
    /// Loads event attendees given an event identifier.
    ///
    /// - Parameters:
    ///   - eventId: Event identifier.
    ///   - parameters: Query parameters.
    ///   - completion: Completion handler with list of attendees.
    func loadEventAttendees(eventId: String,
                            parameters: CommunityParameters,
                            completion: @escaping (_ result: Result<ResponseData<AttendeeList>>) -> Void)
    
    /// Loads event attendees count given an event identifier.
    ///
    /// - Parameters:
    ///   - eventId: Event identifier.
    ///   - term: Optional search term.
    ///   - filterParameters: Filter parameters.
    ///   - searchCriteria: Criteria on which search term is applied.
    ///   - completion: Completion handler with attendees count.
    func loadEventAttendeesCount(eventId: String,
                                 term: String?,
                                 filterParameters: FilterParameters,
                                 searchCriteria: String?,
                                 completion: @escaping (_ result: Result<ResponseData<AttendeeCount>>) -> Void)
    
    /// Bookmarks the event with the given parameters.
    ///
    /// - Parameters:
    ///   - eventId: Event id of the event to bookmark.
    ///   - toggled: If true, send post request, send delete request otherwise.
    ///   - completion: Completion block of the network call.
    func updateBookmark(eventId: String, toggled: Bool, completion: ((_ result: Result<ResponseData<Event>>) -> Void)?)

    /// Loads the event count with the given parameters.
    ///
    /// - Parameters:
    ///   - filters: Selected filter parameters to refine count.
    ///   - rsvped: Boolean flag to only return events that have rsvp:going.
    ///   - waitlisted: Boolean flag to only return events that are waitlisted.
    ///   - bookmarked: Boolean flag to only return events that are bookmarked.
    ///   - completion: Completion block for events count.
    func loadEventCount(filters: FilterParameters,
                        rsvped: Bool?,
                        waitlisted: Bool?,
                        bookmarked: Bool?,
                        completion: @escaping (_ result: Result<ResponseData<EventCount>>) -> Void)
    
    /// Edits guests for a member attending an event.
    ///
    /// - Parameters:
    ///   - eventId: Event identifier.
    ///   - guestData: Guest registration data.
    ///   - completion: Completion handler containing successfully edited guests.
    func editGuests(eventId: String,
                    guestData: [EventGuestRegistrationData],
                    completion: @escaping (_ result: Result<ResponseData<EditGuestsResponse>>) -> Void)

}
