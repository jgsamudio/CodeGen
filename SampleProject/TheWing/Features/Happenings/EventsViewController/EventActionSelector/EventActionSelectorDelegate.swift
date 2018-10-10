//
//  EventActionSelectorDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EventActionSelectorDelegate: class {

    /// Displays an event modal with the given parameters.
    ///
    /// - Parameters:
    ///   - type: Type of the modal to display.
    ///   - eventData: Data for the modal to present.
    func displayEventModal(type: EventModalType, eventData: EventData?)

    /// RSVPs or waitlists the user to the event.
    ///
    /// - Parameter status: Current status to update the user to.
    func rsvpForEvent(status: EventActionButtonSource)

    /// Called when the user wants to add guests to the event.
    ///
    /// - Parameter eventData: Data of the event.
    func addGuestSelected(eventData: EventData)
    
}
