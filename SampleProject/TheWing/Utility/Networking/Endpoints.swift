//
//  Endpoints.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/7/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Contains all of the endpoints for the application.
struct Endpoints {

	// MARK: - Public Properties
    
    // MARK: - Public Properties
    
    // Endpoint for community filters options.
    static let memberFilters = "/community/filters"
    
    // Endpoint for community.
    static let community = "/community"
    
    // Endpoint for happenings.
    static let events = "/events"
    
    /// Endpoint for filter options.
    static let eventFilters = "/events/filters"

    /// Endpoint for getting the authentication token.
    static let login = "/auth/login"

    /// Endpoint for getting the user object after signing in.
    static let user = "/auth/me"

    /// Endpoint for getting the industries.
    static let industries = "/industries"
    
    /// Endpoint for searching for positions.
    static let positions = "/positions"

    /// Endpoint for searching for companies.
    static let companies = "/companies"

    /// Endpoint to get the filter count.
    static let eventsCount = "/events/count"

    /// Endpoint to load the home dashboard.
    static let home = "/home"
    
    /// Endpoint to get ask tags.
    static let asks = "/asks"
    
    /// Endpoint to get offer tags.
    static let offers = "/offers"
    
    /// Endpoint to get interest tags.
    static let interests = "/interests"

    /// Endpoint to get the community count.
    static let memberCount = "/community/count"

    /// Endpoint to get the neighborhoods.
    static let neighborhoods = "/neighborhoods"

    /// Endpoint to update my profile.
    static let updateProfile = "/profile/me"

	// MARK: - Public Functions

    // MARK: - Public Functions
    
    /// Endpoint to update the to do with given identifier.
    ///
    /// - Parameter identifier: Identifier of to do.
    /// - Returns: String endpoint.
    static func acknowledge(identifier: String) -> String {
        return "/todos/\(identifier)/acknowledge"
    }
    
    /// Endpoint to edit user's guests for event with given event identifier.
    ///
    /// - Parameter eventId: Event identifier.
    /// - Returns: String endpoint.
    static func guests(eventId: String) -> String {
        return "/events/\(eventId)/guests"
    }
    
    /// Endpoint to rsvp or cancel rsvp for an event with given event identifier.
    ///
    /// - Parameter eventId: Event identifier.
    /// - Returns: String endpoint.
    static func eventRSVP(eventId: String) -> String {
        return "/events/\(eventId)/rsvp"
    }
    
    /// Endpoint to load event attendees for event with given event identifier.
    ///
    /// - Parameters eventId: Event identifier.
    /// - Returns: String endpoint.
    static func eventAttendees(eventId: String) -> String {
        return "/events/\(eventId)/attendees"
    }
    
    /// Endpoint to load a single event.
    ///
    /// - Parameter eventId: Id of the event to load.
    /// - Returns: Endpoint string of the event.
    static func event(eventId: String) -> String {
        return "/events/\(eventId)"
    }
    
    /// Endpoint to load event attendees count.
    ///
    /// - Parameter eventId: Event identifier.
    /// - Returns: Endpoint string.
    static func attendeesCount(eventId: String) -> String {
        return "\(eventAttendees(eventId: eventId))/count"
    }
    
    /// Endpoint to get a member's profile.
    ///
    /// - Parameter memberId: User id.
    /// - Returns: Endpoint string to get a member's profile.
    static func member(memberId: String) -> String {
        return "/profile/\(memberId)"
    }
    
    /// Endpoint to update the user avatar image.
    ///
    /// - Parameter userId: User Id
    /// - Returns: Endpoint string to update user avatar image.
    static func updateAvatar(userId: String) -> String {
        return "/profile/avatar/\(userId)"
    }

    /// Updates bookmarks status with the given parameters.
    ///
    /// - Parameter eventId: Event id of the event to bookmark.
    /// - Returns: Endpoint string to update bookmark.
    static func bookmark(eventId: String) -> String {
        return "/events/\(eventId)/bookmark"
    }

}
