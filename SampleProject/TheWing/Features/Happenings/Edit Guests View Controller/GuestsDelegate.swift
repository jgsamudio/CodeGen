//
//  GuestsDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

protocol GuestsDelegate: class {
    
    /// Notifies delegate when guests have been updated for event with given event identifier.
    ///
    /// - Parameters:
    ///   - guests: Optional guests.
    ///   - eventId: Event identifier.
    func updatedGuests(_ guests: [Guest]?, eventId: String)
    
}
