//
//  EventListViewDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 7/11/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

protocol EventListViewDelegate: ErrorDelegate {

    /// Displays events.
    func displayEvents()

    /// Notifies view delegate when the page is in loading state or not.
    ///
    /// - Parameter isLoading: True, if is loading, false otherwise.
    func loading(_ isLoading: Bool)

    /// Displays the event modal.
    ///
    /// - Parameter data: Data to display.
    func displayEventModal(data: EventModalData)

    /// Called when the user wants to add guests to the event.
    ///
    /// - Parameter eventData: Data of the event.
    func addGuestSelected(eventData: EventData)

}
