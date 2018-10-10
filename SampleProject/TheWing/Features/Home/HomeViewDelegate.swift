//
//  HomeViewDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

protocol HomeViewDelegate: ErrorDelegate {

    /// Displays the my happenings module view.
    ///
    /// - Parameters:
    ///   - eventData: Event data to display.
    ///   - totalCount: Total count of the user's events.
    //    - showEmptyState: Boolean determining if delegate should show empty state.
    func displayMyHappenings(eventData: [EventData], totalCount: Int, showEmptyState: Bool)

    /// Displays the to do list module.
    func updateToDoList(shouldShow: Bool)

    /// Displays the event modal.
    ///
    /// - Parameters:
    ///   - data: Data to display.
    ///   - type: Event modal type if available.
    func displayEventModal(data: EventModalData)

    /// Called when the user wants to add guests to the event.
    ///
    /// - Parameter eventData: Data of the event.
    func addGuestSelected(eventData: EventData)
    
    /// Dispays the bookmarked events module.
    ///
    /// - Parameters:
    ///   - eventsCount: Count of bookmarked events.
    ///   - showEmptyState: Determines if module should be set to its empty state.
    func displayBookmarkedEventsView(eventsCount: Int, showEmptyState: Bool)

    /// Updates the happenings view with the given parameters.
    ///
    /// - Parameters:
    ///   - eventData: Event data of the event to update.
    ///   - remove: Flag if the event should be removed.
    ///   - animated: Flag to animate the change.
    ///   - collapse: Flag to collapse after the event is removed.
    func updateMyHappening(eventData: EventData, remove: Bool, animated: Bool, collapse: Bool)

    /// Adds an event to the list.
    ///
    /// - Parameter eventData: Event data of the event.
    func addMyHappening(eventData: EventData)

    /// Updates the total happenings count title.
    ///
    /// - Parameter totalCount: Total count to set.
    func updateTotalHappeningsCount(_ totalCount: Int)
    
    /// Notifies delegate to display announcements.
    ///
    /// - Parameter data: Array of announcement data objects.
    func displayAnnouncements(data: [AnnouncementData])

    /// Determines if the home page is loading.
    ///
    /// - Parameter loading: If the network request is loading or not.
    func isLoading(_ loading: Bool)

    /// Notifies delegate to navigate to my bookmarks view.
    func openMyBookmarks()
    
    /// Notifies delegate to navigate to edit profile.
    func openEditProfile()
    
    /// Refreshes header if needed.
    func refreshHeader()
    
    /// Should attempt to present push permission
    func attemptToPresentPushPermission()
    
}
