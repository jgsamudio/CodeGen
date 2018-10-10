//
//  EventDetailViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 4/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EventDetailViewDelegate: ErrorDelegate {
    
    /// Configures the view to be in initial loading state.
    ///
    /// - Parameter initialLoad: True, if in initial loading state, false otherwise.
    func setInitialLoad(_ initialLoad: Bool)
    
    /// Called when view delegate should display header with icon image url.
    ///
    /// - Parameters:
    ///   - title: Header title.
    ///   - headline: Header headline of the event.
    func displayHeader(title: String, headline: String)

    /// Called when delegate should display event badge.
    ///
    /// - Parameter badge: Event badge type.
    func displayBadge(_ badge: EventBadgeType)
    
    /// Called when delegate should display topic icon.
    ///
    /// - Parameter imageURL: Image url.
    func displayTopicIcon(from imageURL: URL)
    
    /// Called when view delegate should display the date and time.
    ///
    /// - Parameters:
    ///   - date: The event date.
    ///   - time: The event time.
    ///   - location: The event location.
    ///   - address: The event address.
    func displayDate(date: String, time: String, location: String, address: String)
    
    /// Called when view delegate should display description.
    ///
    /// - Parameter text: Text description.
    func displayDescription(_ text: String)
    
    /// Displays the buttons with the given types.
    ///
    /// - Parameter statusTypes: Types to display.
    func displayButtons(statusTypes: [EventActionButtonSource])

    /// Displays the member info.
    ///
    /// - Parameter types: Array of the member types.
    func displayMemberInfo(types: [EventMemberType])

    /// Shares the event detail.
    ///
    /// - Parameter message: Message to add when sharing the event.
    func shareEvent(with data: EventData, message: String)

    /// Sets the button view loading state with the given parameters.
    ///
    /// - Parameters:
    ///   - loading: Flag to determine if the button is loading.
    ///   - type: Type of the button set loading status.
    func button(loading: Bool, type: EventActionButtonSource)
    
    /// Displays the event modal.
    ///
    /// - Parameters:
    ///   - data: Data to display.
    func displayEventModal(with data: EventModalData)
    
    /// Displays the fee modal.
    ///
    /// - Parameter data: Event modal data.
    func displayFeeModal(with data: EventModalData)
    
    /// Displays registered members for event.
    ///
    /// - Parameters:
    ///   - show: Flag, if true, sets the display, hides otherwise.
    ///   - attendees: Array of member information.
    ///   - headerText: Header text to display.
    func setAttendees(show: Bool, attendees: [MemberInfo], headerText: String?)

    /// Called when Add Guest button is selected.
    ///
    /// - Parameter eventData: Data of the event.
    func addGuestSelected(eventData: EventData)

    /// Update the bookmark button with the given parameter.
    ///
    /// - Parameter bookmarkInfo: Bookmark info to update.
    func updateBookmark(bookmarkInfo: BookmarkInfo)

    /// Shows the bookmark icon.
    ///
    /// - Parameter show: Flag to show or hide the bookmark icon.
    func showBookmark(show: Bool)
    
    /// Should attempt to present push permission
    func attemptToPresentPushPermission()

    /// Notifies delegate that the page should be in a loading state.
    ///
    /// - Parameter loading: True, if should be in loading state, false otherwise.
    func isLoading(_ loading: Bool)

}
