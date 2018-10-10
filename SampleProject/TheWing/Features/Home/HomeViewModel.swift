//
//  HomeViewModel.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class HomeViewModel {
    
    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    weak var delegate: HomeViewDelegate?
    
    /// User object.
    var user: User? {
        return dependencyProvider.networkProvider.sessionManager.user
    }
    
    /// User name to display in the header title.
    var title: String {
        guard let user = user else {
            return HomeLocalization.homeTabHeaderEmptyTitle
        }
        
        return HomeLocalization.homeTabHeaderTitle(forUsername: user.profile.name.first)
    }
    
    /// Joined date to display in the header subtitle.
    var subtitle: String {
        guard let user = user else {
            return ""
        }
        
        let joinedDate = user.joinedDateString ?? ""
        let title = HomeLocalization.homeTabHeaderSubtitle(forMemberSince: joinedDate)
        return joinedDate.isEmpty ? "" : title
    }
    
    /// Total my happenings count.
    var happeningsCount: Int {
        return eventCache.totalCount
    }
    
    /// Array of announcement data objects
    var announcements = [AnnouncementData]() {
        didSet {
            if !announcements.isEmpty {
                delegate?.displayAnnouncements(data: announcements)
            }
        }
    }
    
    /// Tasks.
    var tasks: [TaskData] = [] {
        didSet {
            delegate?.updateToDoList(shouldShow: !tasks.isEmpty)
        }
    }

    /// Handles the display event logic. Shared with home view model.
    private(set) lazy var eventListActionHandler: EventListActionHandler = {
        let actionHandler = EventListActionHandler(networkProvider: dependencyProvider.networkProvider)
        actionHandler.delegate = self
        return actionHandler
    }()

    // MARK: - Constants

    // MARK: - Private Properties
    
    fileprivate static let eventsLimit = 3
    
    // MARK: - Private Properties
    
    private let dependencyProvider: DependencyProvider
    
    private let analyticsProvider: HomeAnalyticsDelegate

    private var lastPageLoadDate: Date?

    private var eventCache: EventLocalCache {
        return dependencyProvider.networkProvider.eventLocalCache
    }
    
    private var bookmarkedHappeningsCount: Int {
        return eventCache.bookmarkTotalCount
    }
    
    private var homeData: Home? {
        didSet {
            guard let homeData = homeData,
                let events = homeData.response.myHappenings?.events else {
                    return
            }
            self.events = events
            configureHome(homeData: homeData)
        }
    }
    
    private var events = [Event]()

    private lazy var actionSelector: EventActionSelector = {
        let actionSelector = EventActionSelector()
        actionSelector.delegate = eventListActionHandler
        return actionSelector
    }()
    
    private var homeLoader: HomeLoader {
        return dependencyProvider.networkProvider.homeLoader
    }
    
    // MARK: - Initialization
    
    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
        self.analyticsProvider = HomeAnalyticsProvider(dependencyProvider: dependencyProvider)
    }
    
    // MARK: - Public Functions
    
    /// Loads the home data.
    @objc func loadDashboard() {
        delegate?.isLoading(true)
        homeLoader.loadHome(eventsLimit: HomeViewModel.eventsLimit, postLimit: 10) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.delegate?.isLoading(false)
            strongSelf.lastPageLoadDate = Date()
            result.ifSuccess {
                strongSelf.homeData = result.value
            }
        }
    }
    
    /// Reloads user object.
    func reloadUser() {
        dependencyProvider.networkProvider.authLoader.user { [weak self] (result) in
            result.ifSuccess {
                self?.delegate?.refreshHeader()
            }
        }
    }
    
    /// Called when action button is selected.
    ///
    /// - Parameter eventCellData: Event cell data to display.
    func actionButtonSelected(with eventCellData: EventData) {
        guard let action = eventCellData.quickAction else {
            return
        }
        eventListActionHandler.selectedEventCellData = eventCellData
        actionSelector.actionButtonSelected(status: action, eventData: eventCellData)
    }
    
    /// Called when an event is removed from the list.
    ///
    /// - Parameter eventData: Event data of the event removed.
    func eventRemoved(eventData: EventData) {
        events = events.filter { $0.eventId != eventData.eventId }
        checkEmptyState()
        loadNextEvent()
    }
    
    /// Updates the current my happenings list with event cached data.
    func updateMyHappenings() {
        guard user != nil else {
            return
        }
        
        let eventIds = events.map { $0.eventId }
        eventCache.data.forEach {
            if eventIds.contains($0.value.event.eventId) {
                updateDisplayedEvent($0.value.event)
            } else if $0.value.userIsGoing {
                addNewCachedEvent($0.value.event)
            }
        }
        checkEmptyState()
        delegate?.displayBookmarkedEventsView(eventsCount: bookmarkedHappeningsCount,
                                              showEmptyState: bookmarkedHappeningsCount == 0)
    }
    
    /// Handles event for task call to action selected at given index.
    ///
    /// - Parameter index: Index of task.
    func taskActionSelected(at index: Int) {
        guard index < tasks.count else {
            return
        }
        analyticsProvider.trackTaskCTAClicked(data: tasks[index], at: index)
        
        switch tasks[index].actionType {
        case .acknowledge:
            homeLoader.acknowledgeTask(identifier: tasks[index].identifier) { [weak self] (result) in
                result.ifSuccess {
                    guard let success = result.value?.data.acknowledge, success else {
                        self?.delegate?.displayError(nil)
                        return
                    }
                    
                    self?.tasks.remove(at: index)
                }
                result.ifFailure {
                    self?.delegate?.displayError(result.error)
                }
            }
        case .redirect:
            if tasks[index].action == "profile" {
                delegate?.openEditProfile()
            } else if tasks[index].action == "bookmarks" {
                delegate?.openMyBookmarks()
            }
        default:
            break
        }
    }
    
    /// Determines if task at given index is profile-related.
    ///
    /// - Parameter index: Index.
    /// - Returns: True, if profile related task, false otherwise.
    func isProfileTask(at index: Int) -> Bool {
        guard index < tasks.count else {
            return false
        }
        
        return tasks[index].type == .profileIncomplete
    }
    
    /// Handles action for when task did come into focus.
    ///
    /// - Parameter index: Index of task item.
    func taskDidComeIntoFocus(at index: Int) {
        guard index < tasks.count else {
            return
        }
        
        analyticsProvider.trackTaskViewed(data: tasks[index], at: index)
    }

    /// Checks is the home page is out of date
    func resyncHomePage() {
        if BusinessConstants.defaultRefreshInterval.hasElapsed(since: lastPageLoadDate) {
            loadDashboard()
        }
    }
    
}

// MARK: - Private Functions
private extension HomeViewModel {
    
    func configureHome(homeData: Home) {
        tasks = homeData.response.myToDos?.compactMap { TaskData(rawTask: $0) } ?? []
        let myEventCellDataList = events.map { generateEventCellData(event: $0) }
        let eventsCount = homeData.response.myHappenings?.totalCount ?? 0
        delegate?.displayMyHappenings(eventData: myEventCellDataList,
                                      totalCount: eventsCount,
                                      showEmptyState: eventsCount == 0)
        delegate?.displayBookmarkedEventsView(eventsCount: bookmarkedHappeningsCount,
                                              showEmptyState: bookmarkedHappeningsCount == 0)
        announcements = homeData.response.announcements?.compactMap { AnnouncementData(announcement: $0) } ?? []
    }
    
    func generateEventCellData(event: Event) -> EventCellData {
        return EventCellData(event: event, isLastEvent: false, eventCache: eventCache)
    }
    
    func updateDisplayedEvent(_ event: Event) {
        guard eventCache.eventChangedLocally(to: event.eventId) else {
            return
        }
        delegate?.updateMyHappening(eventData: generateEventCellData(event: event),
                                    remove: !eventCache.userIsGoing(to: event.eventId),
                                    animated: false,
                                    collapse: events.count != 1)
    }
    
    func addNewCachedEvent(_ event: Event) {
        guard events.count < HomeViewModel.eventsLimit else {
            return
        }
        events.append(event)
        let myEventCellDataList = events.map { generateEventCellData(event: $0) }
        delegate?.displayMyHappenings(eventData: myEventCellDataList, totalCount: happeningsCount, showEmptyState: false)
    }
    
    func checkEmptyState() {
        guard events.isEmpty else {
            delegate?.updateTotalHappeningsCount(happeningsCount)
            return
        }
        delegate?.displayMyHappenings(eventData: [], totalCount: happeningsCount, showEmptyState: true)
    }
    
    func loadNextEvent() {
        guard HomeViewModel.eventsLimit <= happeningsCount else {
            return
        }
        
        if let nextEvent = eventCache.nextEvent(notFoundIn: events) {
            addNextEvent(nextEvent)
        } else {
            fetchNextEvent()
        }
    }
    
    func fetchNextEvent() {
        let pageSize = 1
        guard happeningsCount > 0 else {
            return
        }
        
        let parameters = EventsParameters(page: happeningsCount - pageSize,
                                          pageSize: pageSize,
                                          searchTerm: nil,
                                          filters: nil,
                                          rsvpFilter: true,
                                          bookmarkedFilter: false,
                                          waitlistedFilter: true)
        dependencyProvider.networkProvider.eventsLoader.loadEvents(parameters: parameters) { (result) in
            result.ifSuccess {
                let events = result.value?.data.events ?? []
                if !(events.map { $0.eventId }).contains(events.first?.eventId) {
                    self.addNextEvent(events.first)
                }
            }
        }
    }
    
    func addNextEvent(_ nextEvent: Event?) {
        guard let nextEvent = nextEvent else {
            return
        }
        events.append(nextEvent)
        delegate?.addMyHappening(eventData: generateEventCellData(event: nextEvent))
    }
    
}

// MARK: - EventStatusDelegate
extension HomeViewModel: EventStatusDelegate {
    
    func eventStatusUpdated(event: Event?) {
        guard let event = event else {
            return
        }
        
        events = events.compactMap {
            $0.eventId == event.eventId ? event : $0
        }
        
        delegate?.updateMyHappening(eventData: generateEventCellData(event: event),
                                    remove: eventCache.eventChangedLocally(to: event.eventId),
                                    animated: true,
                                    collapse: events.count != 1)
    }
    
}

// MARK: - EventListActionDelegate
extension HomeViewModel: EventListActionDelegate {
    
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
    
    func trackCancelAction(type: EventModalType, eventData: EventData) {
        dependencyProvider.analyticsProvider.track(event: AnalyticsEvents.Happenings.cancel.analyticsIdentifier,
                                                   properties: eventData.analyticsProperties(forScreen: self),
                                                   options: nil)
    }
    
    func trackConfirmAction(eventData: EventData, action: EventActionButtonSource) {
        dependencyProvider.analyticsProvider.track(event: AnalyticsEvents.Happenings.rsvp.analyticsIdentifier,
                                                   properties: eventData.analyticsProperties(forScreen: self),
                                                   options: nil)
    }
    
    func trackWaitlistErrorModal(eventData: EventData) {
        dependencyProvider.analyticsProvider.track(event: AnalyticsEvents.Happenings.waitlist.analyticsIdentifier,
                                                   properties: eventData.analyticsProperties(forScreen: self),
                                                   options: nil)
    }
    
}

// MARK: - AnalyticsIdentifiable
extension HomeViewModel: AnalyticsIdentifiable {
    
    var analyticsIdentifier: String {
        return AnalyticsScreen.home.analyticsIdentifier
    }
    
}

// MARK: - EditProfileDelegate
extension HomeViewModel: EditProfileDelegate {
    
    func editProfileCompleted() {
        
    }
    
}
