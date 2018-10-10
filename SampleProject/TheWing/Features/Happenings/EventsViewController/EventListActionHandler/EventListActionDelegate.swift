//
//  EventListActionDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 7/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EventListActionDelegate: class {

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

    /// Tracks the cancel action on the event list item.
    ///
    /// - Parameters:
    ///   - type: Type of the modal.
    ///   - eventData: Event data of the cancelled event.
    func trackCancelAction(type: EventModalType, eventData: EventData)

    /// Tracks the confirmed action of the event list item.
    ///
    /// - Parameters:
    ///   - eventData: Event data of the confirmed event.
    ///   - action: Event action.
    func trackConfirmAction(eventData: EventData, action: EventActionButtonSource)

    /// Tracks a waitlist error modal.
    ///
    /// - Parameter eventData: Event data of the waitlisted event.
    func trackWaitlistErrorModal(eventData: EventData)

    /// Called when the event status is updated.
    ///
    /// - Parameter event: Event object of the updated event.
    func eventStatusUpdated(event: Event?)
    
    /// Should attempt to present push permission
    func attemptToPresentPushPermission()
    
    /// Notifies delegate that an error occurred.
    ///
    /// - Parameter error: Error.
    func showError(_ error: Error?)

}
