//
//  EventsParameters.swift
//  TheWing
//
//  Created by Jonathan Samudio on 7/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Network parameters for the load events network call.
struct EventsParameters {

    // MARK: - Public Properties
    
    /// Page offset.
    let page: Int

    /// Page size.
    let pageSize: Int

    /// Optional search term.
    let searchTerm: String?
    
    /// Optional Filter parameters.
    let filters: FilterParameters?

    /// Flag to show or hide rsvpd events, set to nil for all events regardless of rsvp status.
    let rsvpFilter: Bool?

    /// Flag to show or hide bookmarked events, set to nil for all events regardless of bookmarked status.
    let bookmarkedFilter: Bool?
    
    /// Flag to show or hide waitlisted events, set to nil for all events regardless of waitlist status.
    let waitlistedFilter: Bool?
    
}
