//
//  EventStatusDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EventStatusDelegate: class {

    /// Called when the status of the event is updated.
    ///
    /// - Parameter event: Updated event.
    func eventStatusUpdated(event: Event?)
    
    /// Called when the bookmark is updated from the edp.
    ///
    /// - Parameter data: Data of the event.
    func bookmarkUpdated(data: EventData)

}

extension EventStatusDelegate {

    // MARK: - Public Functions
    
    func bookmarkUpdated(data: EventData) {
        // Optional Method.
    }

}
