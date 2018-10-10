//
//  BaseModalCardDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 5/10/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol BaseModalCardDelegate: class {
    
    /// Called when the close button is selected.
    ///
    /// - Parameter modal: The modal that's closing, investigate it for type for push permission.
    func closeSelected(from modal: EventModal?)
    
    /// Called when the add guest button is selected.
    func addGuestSelected(eventData: EventData)
    
    /// Called when the cancel RSVP button is selected.
    func cancelRSVPSelected()
    
    /// Called when the cancel Waitlist button is selected.
    func cancelWaitlistSelected()
    
    /// Called when the join waitlist button is selected.
    func waitlistSelected()
    
    /// Called when the compose mail button is selected.
    func composeMailSelected()
    
    /// Called when the cancel button is selected.
    func cancelSelected()
    
    /// Called when the confirm RSVP button is selected.
    func confirmRSVPSelected()
    
    /// Called when the join waitlist button is selected.
    func joinWaitlistSelected()
    
}
