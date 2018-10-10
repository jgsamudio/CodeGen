//
//  HomeHappeningsDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol HomeHappeningsDelegate: class {
    
    /// Called when the see all button is selected for the events module.
    func seeAllEventsSelected()

    /// Called when the user selects an event.
    ///
    /// - Parameter eventData: Event data of the selected cell.
    func eventSelected(eventData: EventData)

    /// Called when an event is removed from the list.
    ///
    /// - Parameter eventData: Event data of the event removed.
    func eventRemoved(eventData: EventData)
    
}
