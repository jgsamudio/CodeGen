//
//  EventCellDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EventCellDelegate: class {

    /// Called when the RSVP button is selected.
    func actionButtonSelected(data: EventData)
    
    /// Called when the boomark button is selected.
    func bookmarkSelected(data: EventData?)
    
}

extension EventCellDelegate {

    // MARK: - Public Functions
    
    func bookmarkSelected(data: EventData?) {
        // Optional method.
    }

}
