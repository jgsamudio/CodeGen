//
//  EventListViewModel.swift
//  TheWing
//
//  Created by Jonathan Samudio on 7/11/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Alamofire

/// Base view model for the see all and events view models.
class EventListViewModel {
    
    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    weak var eventListDelegate: EventListViewDelegate?
    
    /// Collection of loaded events.
    var events: [Event] = []

    /// Determines if the load is the initial one.
    var isInitialLoad: Bool = true
    
    /// Dependency provider used to load the events.
    let dependencyProvider: DependencyProvider
    
    var analyticsProvider: AnalyticsProvider {
        return dependencyProvider.analyticsProvider
    }
    
    var eventCountIsLessThanPageSize: Bool {
        return totalEventsCount < BusinessConstants.defaultPageSize
    }

    private(set) lazy var bookmarkProvider: BookmarkStatusProvider = {
        return BookmarkStatusProvider(networkProvider: dependencyProvider.networkProvider)
    }()
    
    private(set) lazy var eventListActionHandler: EventListActionHandler = {
        return EventListActionHandler(networkProvider: dependencyProvider.networkProvider)
    }()

    private(set) var pageIndex = 1

    // MARK: - Private Properties
    
    private var totalEventsCount = 0
    
    private var canFetch = true

    private lazy var actionSelector: EventActionSelector = {
        let actionSelector = EventActionSelector()
        actionSelector.delegate = eventListActionHandler
        return actionSelector
    }()

    // MARK: - Initialization
    
    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
    
    // MARK: - Public Functions
    
    /// Called when action button is selected.
    ///
    /// - Parameter eventCellData: Event cell data to display.
    func actionButtonSelected(with eventCellData: EventData) {
        guard let status = eventCellData.quickAction else {
            return
        }
        eventListActionHandler.selectedEventCellData = eventCellData
        actionSelector.actionButtonSelected(status: status, eventData: eventCellData)
    }
    
    /// Toggles the bookmark status of the event.
    ///
    /// - Parameters:
    ///   - eventData: Event data of the selected event.
    ///   - location: what location are you sending this bookmark status toggle from? Optional, if nil, then no tracking.
    /// - Returns: Is it bookmarked?
    @discardableResult func toggleBookmarkStatus(eventData: EventData) -> Bool {
        return bookmarkProvider.toggleBookmarkStatus(eventId: eventData.eventId)
    }
    
    /// Loads events with the given parameters.
    ///
    /// - Parameters:
    ///   - filters: Used to filter events.
    ///   - searchTerm: Optional search term.
    ///   - rsvpFilter: Optional flag to filter by rsvp.
    ///   - bookmarkedFilter: Optional flag to filter by bookmark status.
    ///   - waitlistedFilter: Optional flag to filter by waitlist status.
    ///   - completion: Completion handler for network event.
    func loadEvents(filters: FilterParameters? = nil,
                    searchTerm: String? = nil,
                    rsvpFilter: Bool? = nil,
                    bookmarkedFilter: Bool? = nil,
                    waitlistedFilter: Bool? = nil,
                    completion: @escaping (_ events: Result<ResponseData<EventList>>) -> Void) {
        guard canFetch else {
            return
        }
        canFetch = false

        let eventsLoader = dependencyProvider.networkProvider.eventsLoader
        let parameters = EventsParameters(page: pageIndex,
                                          pageSize: BusinessConstants.defaultPageSize,
                                          searchTerm: searchTerm,
                                          filters: filters,
                                          rsvpFilter: rsvpFilter,
                                          bookmarkedFilter: bookmarkedFilter,
                                          waitlistedFilter: waitlistedFilter)

        eventListDelegate?.loading(true)
        eventsLoader.loadEvents(parameters: parameters) { [weak self] (result) in
            self?.isInitialLoad = false
            guard let strongSelf = self else {
                return
            }
            result.ifSuccess {
                strongSelf.totalEventsCount = result.value?.meta?.pagination.total ?? 0
                strongSelf.update(with: result.value?.data.events ?? [])
            }
            strongSelf.eventListDelegate?.loading(false)
            completion(result)
        }
    }
    
    /// Resets the pagination of the event list.
    func resetPagination() {
        events.removeAll()
        pageIndex = 1
        canFetch = true
    }

    /// Determines if the user interaction is allowed.
    ///
    /// - Parameter isLoading: Flag to determine if the view is loading.
    /// - Returns: Flag if the user interaction is enabled.
    func userInteractionEnabled(isLoading: Bool) -> Bool {
        return !(isLoading && isInitialLoad)
    }
    
}

// MARK: - Private Functions
private extension EventListViewModel {
    
    func update(with newEvents: [Event]) {
        pageIndex += 1
        events.append(contentsOf: newEvents)
        canFetch = events.count < totalEventsCount
    }
    
}

