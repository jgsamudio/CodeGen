//
//  EventModalActionRouterDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EventModalActionRouterDelegate: GuestsDelegate {
    
    /// Called when the user wants to cancel an RSVP/Waitlist to an event.
    ///
    /// - Parameter type: Event modal type.
    func cancelRsvpForEvent(from type: EventModalType)
    
    /// RSVPs or waitlists the user to the event.
    ///
    /// - Parameter status: Current status to update the user to.
    func rsvpForEvent(status: EventActionButtonSource)

    /// Displays an event modal with the given parameters.
    ///
    /// - Parameters:
    ///   - type: Type of the modal to display.
    ///   - eventData: Data for the modal to present.
    func displayEventModal(type: EventModalType, eventData: EventData?)
    
    /// Used for Analytics: tracks waitlisted action from the RSVP error modal.
    func trackWaitlistedFromErrorModal()
    
    /// You should attempt to present push permission
    func attemptToPresentPushPermission()
    
}
