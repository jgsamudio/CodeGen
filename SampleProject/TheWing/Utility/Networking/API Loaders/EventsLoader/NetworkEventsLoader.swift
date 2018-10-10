//
//  NetworkEventsLoader.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/7/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Alamofire

/// Event API Loader handler network requests from the happenings page.
final class NetworkEventsLoader: Loader, EventsLoader {
    
    // MARK: - Public Functions
    
    func loadEvents(parameters: EventsParameters,
                    completion: @escaping (_ result: Result<ResponseData<EventList>>) -> Void) {
        
    // MARK: - Public Properties
    
        var queryItems = [URLQueryItem(name: "pageSize", value: "\(parameters.pageSize)"),
                          URLQueryItem(name: "page", value: "\(parameters.page)")]
        
        queryItems += parameters.filters?.queryArrayItems() ?? []
        
        if let searchTerm = parameters.searchTerm {
            queryItems.append(URLQueryItem(name: "query", value: searchTerm))
        }
        
        if let showRsvp = parameters.rsvpFilter {
            queryItems.append(queryItemForRSVPFlag(showRsvp))
        }
        
        if let showBookmarked = parameters.bookmarkedFilter {
            queryItems.append(queryItemForBookmarkedFlag(showBookmarked))
        }
        
        if let waitlisted = parameters.waitlistedFilter {
            queryItems.append(queryItemForWaitlistedFlag(waitlisted))
        }
        
        let request = apiRequest(method: .get, endpoint: Endpoints.events, queryItems: queryItems)
        httpClient.perform(request: request) { [weak self] (result: Result<ResponseData<EventList>>) in
            result.ifSuccess {
                self?.eventLocalCache.cacheEventsFromApi(events: result.value?.data.events ?? [])
            }
            completion(result)
        }
    }
    
    func loadEvent(eventId: String,
                   membersLimit: Int,
                   completion: @escaping (_ result: Result<ResponseData<Event>>) -> Void) {
        let queryItems = [URLQueryItem(name: "membersLimit", value: "\(membersLimit)")]
        let request = apiRequest(method: .get, endpoint: Endpoints.event(eventId: eventId), queryItems: queryItems)
        httpClient.perform(request: request, completion: completion)
    }
    
    func loadFilterSections(completion: @escaping (_ result: Result<ResponseData<FilterData>>) -> Void) {
        let request = apiRequest(method: .get, endpoint: Endpoints.eventFilters)
        httpClient.perform(request: request, completion: completion)
    }
    
    func register(eventId: String, completion: @escaping (_ result: Result<ResponseData<Event>>) -> Void) {
        let request = apiRequest(method: .post, endpoint: Endpoints.eventRSVP(eventId: eventId))
        httpClient.perform(request: request) { [weak self] (result: Result<ResponseData<Event>>) in
            result.ifSuccess {
                let isWaitlisted = result.value?.data.userInfo.waitlisted ?? false
                self?.eventLocalCache.cacheRegisteredEvent(isWaitlisted: isWaitlisted,
                                                           eventId: eventId)
            }
            completion(result)
        }
    }
    
    func cancel(eventId: String, completion: @escaping (_ result: Result<ResponseData<Event>>) -> Void) {
        let request = apiRequest(method: .delete, endpoint: Endpoints.eventRSVP(eventId: eventId))
        httpClient.perform(request: request) { [weak self] (result: Result<ResponseData<Event>>) in
            result.ifSuccess {
                self?.eventLocalCache.cacheCancelledEvent(eventId: eventId)
            }
            completion(result)
        }
    }
    
    func loadEventAttendees(eventId: String,
                            parameters: CommunityParameters,
                            completion: @escaping (_ result: Result<ResponseData<AttendeeList>>) -> Void) {
        var queryItems = [URLQueryItem(name: "pageSize", value: "\(parameters.pageSize)"),
                          URLQueryItem(name: "page", value: "\(parameters.page)")]
        
        if let term = parameters.term {
            queryItems.append(queryItemForSearchTerm(term))
        }
        
        if let searchCriteria = parameters.searchCriteria {
            queryItems.append(queryItemForSearchCriteria(searchCriteria))
        }
        
        if let filters = parameters.filters {
            queryItems += filters.queryArrayItems()
        }
        
        let request = apiRequest(method: .get, endpoint: Endpoints.eventAttendees(eventId: eventId), queryItems: queryItems)
        httpClient.perform(request: request, completion: completion)
    }
    
    func loadEventAttendeesCount(eventId: String,
                                 term: String?,
                                 filterParameters: FilterParameters,
                                 searchCriteria: String?,
                                 completion: @escaping (_ result: Result<ResponseData<AttendeeCount>>) -> Void) {
        var queryItems = filterParameters.queryArrayItems()
        
        if let term = term {
            queryItems.append(queryItemForSearchTerm(term))
        }
        
        if let searchCriteria = searchCriteria {
            queryItems.append(queryItemForSearchCriteria(searchCriteria))
        }
        
        let request = apiRequest(method: .get, endpoint: Endpoints.attendeesCount(eventId: eventId), queryItems: queryItems)
        httpClient.perform(request: request, completion: completion)
    }
    
    func editGuests(eventId: String,
                    guestData: [EventGuestRegistrationData],
                    completion: @escaping (Result<ResponseData<EditGuestsResponse>>) -> Void) {
        let params = ["guests": guestData.map { $0.parameters }]
        let request = apiRequest(method: .put, endpoint: Endpoints.guests(eventId: eventId), parameters: params)
        httpClient.perform(request: request, completion: completion)
    }
    
    func loadEventCount(filters: FilterParameters,
                        rsvped: Bool? = nil,
                        waitlisted: Bool? = nil,
                        bookmarked: Bool? = nil,
                        completion: @escaping (_ result: Result<ResponseData<EventCount>>) -> Void) {
        
        var queryItems = filters.queryArrayItems()
        
        if let rsvped = rsvped {
            queryItems.append(queryItemForRSVPFlag(rsvped))
        }
        
        if let bookmarked = bookmarked {
            queryItems.append(queryItemForBookmarkedFlag(bookmarked))
        }
        
        if let waitlisted = waitlisted {
            queryItems.append(queryItemForWaitlistedFlag(waitlisted))
        }
        
        let request = apiRequest(method: .get, endpoint: Endpoints.eventsCount, queryItems: queryItems)
        httpClient.perform(request: request, completion: completion)
    }
    
    func updateBookmark(eventId: String, toggled: Bool, completion: ((_ result: Result<ResponseData<Event>>) -> Void)?) {
        let request = apiRequest(method: toggled ? .post : .delete,
                                 endpoint: Endpoints.bookmark(eventId: eventId), parameters: nil)
        toggled ? eventLocalCache.cacheAddBookmark(eventId: eventId) : eventLocalCache.cacheRemoveBookmark(eventId: eventId)
        httpClient.perform(request: request) { [weak self] (result: Result<ResponseData<Event>>) in
            self?.bookmarkRequest(result: result, completion: completion)
        }
    }
    
}

// MARK: - Private Functions
private extension NetworkEventsLoader {
    
    func queryItemForSearchTerm(_ term: String) -> URLQueryItem {
        return URLQueryItem(name: CommunityParameters.termLabel, value: term)
    }
    
    func queryItemForSearchCriteria(_ searchCriteria: String) -> URLQueryItem {
        return URLQueryItem(name: CommunityParameters.searchCriteriaLabel, value: searchCriteria)
    }
    
    func queryItemForRSVPFlag(_ flag: Bool) -> URLQueryItem {
        return URLQueryItem(name: "rsvpd", value: flag ? "true" : "false")
    }
    
    func queryItemForBookmarkedFlag(_ flag: Bool) -> URLQueryItem {
        return URLQueryItem(name: "bookmarked", value: flag ? "true" : "false")
    }
    
    func queryItemForWaitlistedFlag(_ flag: Bool) -> URLQueryItem {
        return URLQueryItem(name: "waitlisted", value: flag ? "true" : "false")
    }
    
    func bookmarkRequest(result: Result<ResponseData<Event>>,
                         completion: ((_ result: Result<ResponseData<Event>>) -> Void)?) {
        result.ifSuccess {
            loadEventCount(filters: [:], bookmarked: true, completion: { [weak self] (eventCountResult) in
                eventCountResult.ifSuccess {
                    self?.eventLocalCache.cacheBookmarkTotalCount(eventCountResult.value?.data.events ?? 0)
                }
                completion?(result)
            })
        }
        result.ifFailure {
            completion?(result)
        }
    }
    
}
