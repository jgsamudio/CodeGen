//
//  EventDetailViewModel.swift
//  TheWing
//
//  Created by Luna An on 4/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class EventDetailViewModel {
    
    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    weak var delegate: EventDetailViewDelegate?
    
    /// Delegate for updating event status.
    weak var eventStatusDelegate: EventStatusDelegate?
    
    /// Guest per member count.
    var guestPerMember: Int {
        return eventData?.guestPerMember ?? 0
    }
    
    /// Event identifier.
    var eventId: String
    
    /// Information to display in personal calendar.
    var calendarInfo: EventCalendarInfo? {
        guard let data = eventData else {
            return nil
        }
        
        return data.eventCalendarInfo
    }
    
    /// Title for all attendees view.
    var allAttendeesTitle: String {
        guard let event = event else {
            return "ALL_ATTENDEES".localized(comment: "All Attendees")
        }
        
        return String(format: "ALL_ATTENDEES_COUNT".localized(comment: "All Attendees Count"), "\(event.attendeeCount)")
    }
    
    /// Address string.
    var addressString: String? {
        return eventData?.formattedAddress
    }
    
    // MARK: - Private Properties
    
    private let dependencyProvider: DependencyProvider
    
    private var analyticsProvider: AnalyticsProvider {
        return dependencyProvider.analyticsProvider
    }
    
    private var prefetchedData: EventData?
    
    private var eventDetailData: EventDetailData? {
        guard let event = event  else {
            return nil
        }
        let bookmarkInfo = bookmarkProvider.bookmarkInfo(eventId: event.eventId)
        let eventCache = dependencyProvider.networkProvider.eventLocalCache
        return EventDetailData(event: event, bookmarkInfo: bookmarkInfo, eventCache: eventCache)
    }
    
    private var event: Event? {
        didSet {
            configureEvent()
            eventStatusDelegate?.eventStatusUpdated(event: event)
        }
    }
    
    private var eventData: EventData? {
        return eventDetailData ?? prefetchedData
    }
    
    private lazy var actionSelector: EventActionSelector = {
        let actionSelector = EventActionSelector()
        actionSelector.delegate = self
        actionSelector.bookmarkDelegate = self
        return actionSelector
    }()
    
    private lazy var bookmarkProvider: BookmarkStatusProvider = {
        let provider = BookmarkStatusProvider(networkProvider: dependencyProvider.networkProvider)
        provider.delegate = self
        return provider
    }()
    
    private lazy var reachabilityNotifier = ReachabilityNotifier(delegate: self)
    
    private var isInitialLoad: Bool? {
        didSet {
            if let inititialLoad = isInitialLoad {
                delegate?.setInitialLoad(inititialLoad)
            }
        }
    }
    
    // MARK: - Initialization
    
    init(eventId: String,
         prefetchedData: EventData?,
         dependencyProvider: DependencyProvider) {
        self.eventId = eventId
        self.prefetchedData = prefetchedData
        self.dependencyProvider = dependencyProvider
        reachabilityNotifier.subscribeToReachabilityChanges()
    }
    
    // MARK: - Public Functions
    
    /// Loads prefetched event data into view.
    func loadPrefetchedData() {
        guard let data = prefetchedData else {
            isInitialLoad = true
            return
        }
        
        configurePartialEvent(data: data)
    }
    
    /// Loads event information from API.
    func loadEvent() {
        let eventsLoader = dependencyProvider.networkProvider.eventsLoader
        delegate?.isLoading(true)
        eventsLoader.loadEvent(eventId: eventId, membersLimit: 10) { [weak self] (result) in
            self?.delegate?.isLoading(false)
            
            result.ifSuccess {
                self?.isInitialLoad = false
                self?.event = result.value?.data
            }
            result.ifFailure {
                self?.delegate?.displayError(result.error)
            }
        }
    }
    
    /// Share event.
    func shareEvent() {
        guard let shareableObject = createShareableObject(), let data = eventData else {
            return
        }
        
        let title = data.title
        let locationName = data.location.name
        let timeZoneId = data.location.timeZoneId
        let date = EventStringFormatter.formatAbbreviatedDayString(data.startDate,
                                                                   timeZoneId: timeZoneId).capitalized
        let time = EventStringFormatter.formatTimeString(data.startDate, timeZoneId: timeZoneId)
        DeepLinkGenerator.generateDeeplinkURL(for: shareableObject, completion: { (urlString) in
            self.delegate?.shareEvent(with: data,
                                      message: String(format: "SHARE_EDP_MESSAGE".localized(comment: "Share EDP message"),
                                                      title, locationName, date, time, urlString))
        }) {
            let eventPath = "\(DeepLinkURLs.happenings)\(shareableObject.objectId)"
            self.delegate?.shareEvent(with: data,
                                      message: String(format: "SHARE_EDP_MESSAGE".localized(comment: "Share EDP message"),
                                                      title, locationName, date, time, eventPath))
        }
    }
    
    /// Updates the event with the givent status.
    ///
    /// - Parameter status: Status of the button view that was selected.
    func updateEvent(status: EventActionButtonSource) {
        guard let data = eventData else {
            return
        }
        
        actionSelector.actionButtonSelected(status: status, eventData: data)
    }
    
    /// Displays fee information.
    func displayFeeInformation() {
        guard let data = eventData else {
            return
        }
        
        delegate?.displayFeeModal(with: EventModalData(eventData: data, type: EventModalType.feeExplanation))
    }
    
    /// Toggles the bookmark status of the event.
    /// Returns if bookmarked
    @discardableResult func toggleBookmarkStatus() -> Bool {
        bookmarkProvider.toggleBookmarkStatus(eventId: eventId)
        
        guard let eventData = eventData else {
            return false
        }
        
        let event = eventData.bookmarkInfo.isBookmarked ?
            AnalyticsEvents.Happenings.removeBookmark :
            AnalyticsEvents.Happenings.bookmark
        
        analyticsProvider.track(event: event.analyticsIdentifier,
                                properties: eventData.analyticsProperties(forScreen: self),
                                options: nil)
        
        return eventData.bookmarkInfo.isBookmarked
    }
    
}

// MARK: - Private Functions
private extension EventDetailViewModel {
    
    func configureEvent() {
        guard let event = event, let data = eventData else {
            return
        }
        
        configurePartialEvent(data: data)
        configureAttendees(event.attendees, totalCount: event.attendeeCount)
    }
    
    func configurePartialEvent(data: EventData) {
        var headline = data.topic.uppercased()
        if let format = data.format {
            headline += "\(ViewConstants.dot)\(format.capitalized)"
        }
        
        delegate?.displayHeader(title: data.title, headline: headline)
        delegate?.displayMemberInfo(types: data.eventMemberTypes)
        delegate?.displayDate(date: data.day, time: data.time, location: data.locationName, address: data.formattedAddress)
        delegate?.displayDescription(data.description)
        delegate?.displayButtons(statusTypes: data.actions)
        configureBookmark(data: data)
        configureIcon()
    }
    
    func configureBookmark(data: EventData) {
        delegate?.updateBookmark(bookmarkInfo: data.bookmarkInfo)
        delegate?.showBookmark(show: data.showBookmark)
    }
    
    func configureAttendees(_ attendees: [Member], totalCount: Int) {
        let members = attendees.map { MemberInfo(member: $0) }
        let isEmpty = totalCount == 0
        let header = isEmpty ? nil : String(format: "ATTENDEES".localized(comment: "Attendees"), "\(totalCount)")
        delegate?.setAttendees(show: !isEmpty, attendees: members, headerText: header)
    }
    
    func createShareableObject() -> EventShareableObject? {
        guard let data = eventData else {
            return nil
        }
        
        return EventShareableObject(eventData: data)
    }
    
    func openEventModal(type: EventModalType) {
        guard let data = eventData else {
            return
        }
        
        delegate?.displayEventModal(with: EventModalData(eventData: data, type: type))
    }
    
    private func configureIcon() {
        guard let eventData = eventData else {
            return
        }
        
        if let badge = EventBadgeType.badgeFor(eventData) {
            delegate?.displayBadge(badge)
        } else if let imageURL = eventData.topicIconURL {
            delegate?.displayTopicIcon(from: imageURL)
        }
    }
    
}

// MARK: - EventModalActionRouterDelegate
extension EventDetailViewModel: EventModalActionRouterDelegate {
    
    func attemptToPresentPushPermission() {
        delegate?.attemptToPresentPushPermission()
    }
    
    func updatedGuests(_ guests: [Guest]?, eventId: String) {
        loadEvent()
    }
    
    func displayEventModal(type: EventModalType, eventData: EventData?) {
        openEventModal(type: type)
    }
    
    func cancelRsvpForEvent(from type: EventModalType) {
        let status = EventActionButtonSource.rsvp(isGoing: true)
        analyticsProvider.track(event: AnalyticsEvents.Happenings.cancel.analyticsIdentifier,
                                properties: eventData?.analyticsProperties(forScreen: self),
                                options: nil)
        delegate?.button(loading: true, type: status)
        delegate?.isLoading(true)
        dependencyProvider.networkProvider.eventsLoader.cancel(eventId: eventId) { [weak self] (result) in
            self?.delegate?.isLoading(false)
            self?.delegate?.button(loading: false, type: status)
            result.ifSuccess {
                self?.event = result.value?.data
            }
            result.ifFailure {
                self?.delegate?.displayError(result.error)
            }
        }
    }
    
    func rsvpForEvent(status: EventActionButtonSource) {
        analyticsProvider.track(event: AnalyticsEvents.Happenings.rsvp.analyticsIdentifier,
                                properties: eventData?.analyticsProperties(forScreen: self),
                                options: nil)
        delegate?.button(loading: true, type: status)
        delegate?.isLoading(true)
        dependencyProvider.networkProvider.eventsLoader.register(eventId: eventId) { [weak self] (result) in
            self?.delegate?.isLoading(false)
            self?.delegate?.button(loading: false, type: status)
            result.ifSuccess {
                self?.event = result.value?.data
                if status.typeId == EventActionButtonSource.rsvp(isGoing: false).typeId {
                    if let going = result.value?.data.userInfo.going, going {
                        self?.openEventModal(type: .rsvp)
                    } else if let waitlisted = result.value?.data.waitlisted, waitlisted {
                        self?.openEventModal(type: .waitlist)
                    } else {
                        self?.delegate?.displayError(result.error)
                    }
                }
            }
            result.ifFailure {
                self?.delegate?.displayError(result.error)
            }
        }
    }
    
    func trackWaitlistedFromErrorModal() {
        analyticsProvider.track(event: AnalyticsEvents.Happenings.waitlist.analyticsIdentifier,
                                properties: eventData?.analyticsProperties(forScreen: self),
                                options: nil)
    }
    
}

// MARK: - EventActionSelectorDelegate
extension EventDetailViewModel: EventActionSelectorDelegate {
    
    func addGuestSelected(eventData: EventData) {
        delegate?.addGuestSelected(eventData: eventData)
    }
    
}

// MARK: - EventBookmarkActionDelegate
extension EventDetailViewModel: EventBookmarkActionDelegate {
    
    func bookmarkEventSelected(isBookmarked: Bool) {
        toggleBookmarkStatus()
    }
    
}

// MARK: - BookmarkStatusDelegate
extension EventDetailViewModel: BookmarkStatusDelegate {
    
    func handleError(_ error: Error?) {
        delegate?.displayError(error)
    }
    
    func updateBookmark(eventId: String, status: Bool) {
        guard let eventDetailData = eventDetailData else {
            return
        }
        delegate?.displayButtons(statusTypes: eventDetailData.actions)
        delegate?.updateBookmark(bookmarkInfo: eventDetailData.bookmarkInfo)
        eventStatusDelegate?.bookmarkUpdated(data: eventDetailData)
        if status {
            delegate?.attemptToPresentPushPermission()
        }
    }
    
}

// MARK: - AnalyticsIdentifiable
extension EventDetailViewModel: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.eventDetail.analyticsIdentifier
    }
    
}

// MARK: - AnalyticsRepresentable
extension EventDetailViewModel: AnalyticsRepresentable {
    
    var analyticsProperties: [String: Any] {
        return eventData?.analyticsProperties ?? [:]
    }
    
}

// MARK: - ReachabilityNotifierDelegate
extension EventDetailViewModel: ReachabilityNotifierDelegate {
    
    func networkReachable() {
        if event == nil {
            loadEvent()
        }
    }
    
}
