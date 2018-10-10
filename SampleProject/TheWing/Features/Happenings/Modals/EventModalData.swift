//
//  EventModalData.swift
//  TheWing
//
//  Created by Luna An on 5/22/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class EventModalData {
    
    // MARK: - Public Properties
    
    let eventData: EventData
    
    /// Event modal type that's unique to Event Modal Data class.
    let type: EventModalType
    
    // MARK: - Initialization
    
    init(eventData: EventData, type: EventModalType) {
        self.eventData = eventData
        self.type = type
    }
    
    /// Indicates if the event is for members only.
    ///
    /// - Returns: True or false.
    var guestRegistrationOpen: Bool {
        return eventData.guestFormsCount > 0
    }
    
}
