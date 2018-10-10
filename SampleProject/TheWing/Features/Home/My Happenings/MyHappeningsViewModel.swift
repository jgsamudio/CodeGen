//
//  MyHappeningsViewModel.swift
//  TheWing
//
//  Created by Jonathan Samudio on 7/11/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

final class MyHappeningsViewModel: EventListViewModel {
    
    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    weak var delegate: MyHappeningsViewDelegate? {
        didSet {
            eventListDelegate = delegate
        }
    }
    
    // MARK: - Private Properties
    
    private var happeningsCount: Int {
        return type.happeningsCount(eventCache: dependencyProvider.networkProvider.eventLocalCache)
    }
    
    private var type: MyHappeningsType
    
    // MARK: - Initialization
    
    /// Initialization method for the my happenings view model.
    ///
    /// - Parameters:
    ///   - dependencyProvider: Dependency provider of the application.
    ///   - type: Used to select between my happenings and bookmarked happenings.
    init(dependencyProvider: DependencyProvider, type: MyHappeningsType) {
        self.type = type
        super.init(dependencyProvider: dependencyProvider)
        bookmarkProvider.delegate = self
        eventListActionHandler.delegate = self
    }
    
    // MARK: - Public Functions
    
    override func toggleBookmarkStatus(eventData: EventData) -> Bool {
        let bookmarked = super.toggleBookmarkStatus(eventData: eventData)
        let event = eventData.bookmarkInfo.isBookmarked ?
            AnalyticsEvents.Happenings.removeBookmark :
            AnalyticsEvents.Happenings.bookmark
        analyticsProvider.track(event: event.analyticsIdentifier,
                                properties: eventData.analyticsProperties(forScreen: self),
                                options: nil)
        return bookmarked
    }
    
    /// Loads the user's my happenings.
    func loadEvents() {
        delegate?.set(isLoading: true)
        updateNavigationTitle()
        loadEvents(rsvpFilter: type.rsvpOnly,
                   bookmarkedFilter: type.bookmarksOnly,
                   waitlistedFilter: type.waitlistedFilter) { [weak self] (result) in
                    result.ifSuccess {
                        self?.delegate?.displayEvents()
                    }
                    self?.delegate?.set(isLoading: false)
        }
    }
    
    /// Returns the event cell data for a given index.
    ///
    /// - Parameters:
    ///   - index: Index of the event.
    /// - Returns: Event cell data.
    func eventData(index: Int) -> EventCellData? {
        guard events.count > index else {
            return nil
        }
        
        let event = events[index]
        let bookmarkInfo = bookmarkProvider.bookmarkInfo(eventId: event.eventId)
        let isLastEvent = event.eventId == events.last?.eventId
        let eventCache = dependencyProvider.networkProvider.eventLocalCache
        return EventCellData(event: event, isLastEvent: isLastEvent, bookmarkInfo: bookmarkInfo, eventCache: eventCache)
    }
    
    /// Returns identifier for an event at a given index.
    ///
    /// - Parameters:
    ///   - index: Index in section.
    /// - Returns: Event identifier string.
    func eventID(index: Int) -> String {
        return events[index].eventId
    }
    
    /// Number of rows to display with the given parameters.
    ///
    /// - Parameter section: Section to display.
    /// - Returns: Number of rows to display.
    func numberOfRows(in section: Int) -> Int {
        guard !isInitialLoad else {
            return 7
        }
        return events.count
    }
    
}

// MARK: - Private Functions
private extension MyHappeningsViewModel {
    
    func reload(eventId: String) {
        updateNavigationTitle()
        for index in 0..<events.count {
            if events[index].eventId == eventId {
                delegate?.reloadEventCell(row: index)
                return
            }
        }
    }
    
    func updateNavigationTitle() {
        let navigationTitle = HomeLocalization.navigationTitle(forType: type, andHappeningsCount: happeningsCount)
        delegate?.setNavigationTitle(navigationTitle)
    }
    
}

// MARK: - EventStatusDelegate
extension MyHappeningsViewModel: EventStatusDelegate {
    
    func eventStatusUpdated(event: Event?) {
        guard let event = event else {
            return
        }
        events = events.map { $0.eventId == event.eventId ? event : $0 }
        reload(eventId: event.eventId)
    }
    
    func bookmarkUpdated(data: EventData) {
        reload(eventId: data.eventId)
    }
    
}

// MARK: - BookmarkStatusDelegate
extension MyHappeningsViewModel: BookmarkStatusDelegate {
    
    func handleError(_ error: Error?) {
        delegate?.displayError(error)
    }
    
    func updateBookmark(eventId: String, status: Bool) {
        reload(eventId: eventId)
        if status {
            delegate?.attemptToPresentPushPermission()
        }
    }
    
}

// MARK: - EventListActionDelegate
extension MyHappeningsViewModel: EventListActionDelegate {
    
    func attemptToPresentPushPermission() {
        delegate?.attemptToPresentPushPermission()
    }
    
    func showError(_ error: Error?) {
        delegate?.displayError(error)
    }
    
    func displayEventModal(data: EventModalData) {
        delegate?.displayEventModal(data: data)
    }
    
    func addGuestSelected(eventData: EventData) {
        delegate?.addGuestSelected(eventData: eventData)
    }
    
    func trackConfirmAction(eventData: EventData, action: EventActionButtonSource) {
        analyticsProvider.track(event: AnalyticsEvents.Happenings.rsvp.analyticsIdentifier,
                                properties: eventData.analyticsProperties(forScreen: self),
                                options: nil)
    }
    
    func trackCancelAction(type: EventModalType, eventData: EventData) {
        analyticsProvider.track(event: AnalyticsEvents.Happenings.cancel.analyticsIdentifier,
                                properties: eventData.analyticsProperties(forScreen: self),
                                options: nil)
    }
    
    func trackWaitlistErrorModal(eventData: EventData) {
        analyticsProvider.track(event: AnalyticsEvents.Happenings.waitlist.analyticsIdentifier,
                                properties: eventData.analyticsProperties(forScreen: self),
                                options: nil)
    }
    
}

// MARK: - AnalyticsIdentifiable
extension MyHappeningsViewModel: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.myEvents.analyticsIdentifier
    }
    
}
