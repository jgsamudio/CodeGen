//
//  EventsViewModel.swift
//  TheWing
//
//  Created by Ruchi Jain on 2/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation
import Alamofire

/// Events view model.
final class EventsViewModel: EventListViewModel {
    
    // MARK: - Public Properties
    
    var sections = [DateComponents: [Event]]()

    var sortedSections = [DateComponents]()

    /// Number of sections to display.
    var numberOfSections: Int {
        return isInitialLoad ? 1 : sections.count
    }

    /// Binding delegate for the view model.
    weak var delegate: EventsViewDelegate? {
        didSet {
            eventListDelegate = delegate
        }
    }
    
    /// Event filter items delegate.
    weak var filterItemsDelegate: FilterItemsDelegate?
    
    /// Filter type.
    var filterType: FilterType {
        return .events
    }
    
    /// Optional search term.
    var searchTerm: String?
    
    // MARK: - Private Properties
    
    private var filters = SectionedFilterParameters() {
        didSet {
            reset()
        }
    }

    private var lastPageLoadDate: Date?

    private var isFilterEdited = false

    // MARK: - Initialization
    
    override init(dependencyProvider: DependencyProvider) {
        super.init(dependencyProvider: dependencyProvider)
        bookmarkProvider.delegate = self
        eventListActionHandler.delegate = self
    }
    
    // MARK: - Public Functions

    /// Loads the events list from the API.
    func loadEvents() {
        updateFilterCount()

        let currentPageIndex = pageIndex
        loadEvents(filters: FilterFormatter.formatFilter(UserDefaults.standard.eventFilters),
                   searchTerm: searchTerm?.whitespaceTrimmedAndNilIfEmpty) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.handleEventsResponse(result: result, currentPageIndex: currentPageIndex)
        }
    }
    
    /// Returns the event cell data given a section and an index.
    ///
    /// - Parameters:
    ///   - section: Section of the event.
    ///   - index: Index of the event.
    /// - Returns: Event cell data.
    func eventData(section: Int, index: Int) -> EventCellData? {
        guard events.count > 0, let sortedSection = sortedSections[safe: section] else {
            return nil
        }

        let sectionEvents = sections[sortedSection] ?? []
        let event = sectionEvents[index]
        let bookmarkInfo = bookmarkProvider.bookmarkInfo(eventId: event.eventId)
        let eventCache = dependencyProvider.networkProvider.eventLocalCache
        let isLastEvent = (index == (sectionEvents.count - 1))
        return EventCellData(event: event, isLastEvent: isLastEvent, bookmarkInfo: bookmarkInfo, eventCache: eventCache)
    }
    
    /// Returns identifier for event at given section and index.
    ///
    /// - Parameters:
    ///   - section: Section.
    ///   - index: Index in section.
    /// - Returns: Event identifier string.
    func eventID(section: Int, index: Int) -> String {
        let sectionEvents = sections[sortedSections[section]] ?? []
        let event = sectionEvents[index]
        return event.eventId
    }
    
    /// Updates the loaded events.
    func updateLoadedEvents() {
        guard !events.isEmpty, dependencyProvider.networkProvider.sessionManager.user != nil else {
            return
        }
        events.forEach {
            if dependencyProvider.networkProvider.eventLocalCache.eventChangedLocally(to: $0.eventId) {
                reload(eventId: $0.eventId)
            }
        }
    }

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
    
    /// Number of rows to display with the given parameters.
    ///
    /// - Parameter section: Section to display.
    /// - Returns: Number of rows to display.
    func numberOfRows(in section: Int) -> Int {
        guard !isInitialLoad else {
            return 5
        }
        return sections[sortedSections[section]]?.count ?? 0
    }

    /// Date components of the given section.
    ///
    /// - Parameter section: Section used to find the date components.
    /// - Returns: Optional date components.
    func dateComponents(for section: Int) -> DateComponents? {
        guard sortedSections.count > section else {
            return nil
        }
        return sortedSections[section]
    }

    /// Resets all properties and reloads, good for refreshing.
    func reset() {
        UserDefaults.standard.eventFilters = filters
        sections.removeAll()
        sortedSections.removeAll()
        resetPagination()
        delegate?.reset()
        isInitialLoad = true
        loadEvents()
    }

    /// Checks is the events page is out of date.
    func resyncEventsPage() {
        if BusinessConstants.defaultRefreshInterval.hasElapsed(since: lastPageLoadDate) {
            reset()
        }
    }
    
    func resetSearchAndFilter() {
        searchTerm = nil
        editedFilters([:], count: 0)
    }
    
    func search(_ searchTerm: String?) {
        guard searchTerm?.whitespaceTrimmedAndNilIfEmpty != self.searchTerm?.whitespaceTrimmedAndNilIfEmpty else {
            return
        }
        
        self.searchTerm = searchTerm
        reset()
    }

}

// MARK: - Private Functions
private extension EventsViewModel {

    func configureEvents(newEvents: [Event]) {
        for event in newEvents {
            guard let dateObject = EventStringFormatter.date(for: event.startDateString) else {
                continue
            }
            let dateComponent = Calendar.current.dateComponents([.year, .month, .day], from: dateObject)

            if sections.index(forKey: dateComponent) == nil {
                sections[dateComponent] = [event]
            } else {
                sections[dateComponent]?.append(event)
            }

            sortedSections = sections.keys.sorted(by: {$0 < $1})
        }
    }

    private func reload(eventId: String) {
        for (date, events) in sections {
            for index in 0..<events.count {
                if events[index].eventId == eventId, let section = sortedSections.index(of: date) {
                    delegate?.reloadEventCell(at: section, row: index)
                    return
                }
            }
        }
    }

    func updateFilterCount() {
        delegate?.setFilterCount(FilterFormatter.formatFilter(UserDefaults.standard.eventFilters).count)
    }

    func handleEventsResponse(result: Result<ResponseData<EventList>>, currentPageIndex: Int) {
        if currentPageIndex == 1 {
            lastPageLoadDate = Date()
        }

        result.ifSuccess {
            configureEvents(newEvents: result.value?.data.events ?? [])
            filterItemsDelegate?.itemsLoadingSuccessful()
            delegate?.displayEvents()
        }
        result.ifFailure {
            filterItemsDelegate?.itemsLoaded(withError: result.error)
        }

        if currentPageIndex == 1 {
            delegate?.displayNoResultsView(show: events.isEmpty)
        }
    }

}

// MARK: - FiltersDelegate
extension EventsViewModel: FiltersDelegate {
    
    func loadResultsCount(filters: FilterParameters, completion: @escaping (Int?, Error?) -> Void) {
        let loader = dependencyProvider.networkProvider.eventsLoader
        loader.loadEventCount(filters: filters, rsvped: nil, waitlisted: nil, bookmarked: nil) { (result) in
            result.ifSuccess {
                completion(result.value?.data.events, nil)
            }
            result.ifFailure {
                completion(nil, result.error)
            }
        }
    }
    
    func editedFilters(_ filters: SectionedFilterParameters, count: Int) {
        self.filters = filters
        isFilterEdited = true
        delegate?.setFilterCount(count)
        UserDefaults.standard.eventFilters = filters
    }

}

// MARK: - EventStatusDelegate
extension EventsViewModel: EventStatusDelegate {

    func eventStatusUpdated(event: Event?) {
        guard let event = event else {
            return
        }
        for (dateComponents, cellEvents) in sections {
            if let index = cellEvents.index(where: { $0.eventId == event.eventId }),
                let sectionIndex = sortedSections.index(where: { $0 == dateComponents }) {
                sections[dateComponents] = cellEvents.map({
                    if $0.eventId == event.eventId {
                        return event
                    }
                    return $0
                })
                delegate?.reloadEventCell(at: sectionIndex, row: index)
                return
            }
        }
    }

    func bookmarkUpdated(data: EventData) {
        reload(eventId: data.eventId)
    }

}

// MARK: - BookmarkStatusDelegate
extension EventsViewModel: BookmarkStatusDelegate {

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
extension EventsViewModel: EventListActionDelegate {
    
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
        if action.typeId == EventActionButtonSource.rsvp(isGoing: false).typeId {
            analyticsProvider.track(event: AnalyticsEvents.Happenings.rsvp.analyticsIdentifier,
                                    properties: eventData.analyticsProperties(forScreen: self),
                                    options: nil)
        } else if action.typeId == EventActionButtonSource.waitlist(isWaitlisted: false).typeId {
            analyticsProvider.track(event: AnalyticsEvents.Happenings.waitlist.analyticsIdentifier,
                                    properties: eventData.analyticsProperties(forScreen: self),
                                    options: nil)
        }
    }

    func trackCancelAction(type: EventModalType, eventData: EventData) {
        if type == .cancelRSVP || type == .cancelWaitlist {
            analyticsProvider.track(event: AnalyticsEvents.Happenings.cancel.analyticsIdentifier,
                                    properties: eventData.analyticsProperties(forScreen: self),
                                    options: nil)
        }
    }

    func trackWaitlistErrorModal(eventData: EventData) {
        analyticsProvider.track(event: AnalyticsEvents.Happenings.waitlist.analyticsIdentifier,
                                properties: eventData.analyticsProperties(forScreen: self),
                                options: nil)
    }

}

// MARK: - AnalyticsIdentifiable
extension EventsViewModel: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.events.analyticsIdentifier
    }
    
}
