//
//  Event.swift
//  TheWing
//
//  Created by The Wing Developers on 08/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Event: Codable {
    
    // MARK: - Public Properties
    
	let attendeesInfo: AttendeesInfo? // let attendeesInfo: AttendeesInfo?
	let availableCapacity: Int? // let availableCapacity: Int
	let availableUserGuests: Int? // let availableUserGuests: Int?
	let capacity: Int? // let capacity: Int
	let description: String
	let endDateString: String? // let endDate: String
	let eventId: String
	let fee: Double? // let fee: Bool
	let format: Format? // let format: Format?
	let guestCapacity: Int?
	let guestPerMember: Int? // let guestPerMember: Int
	let guestsInfo: GuestsInfo? // let guestsInfo: GuestsInfo
	let happeningPhoto: String
	let hasWaitlist: Bool // let isWaitlisted: Bool
	let location: Location
	let rsvpOpenDateString: String? // let rsvpOpenDate: String
	let startDateString: String // let startDate: String
	let title: String
	let topic: Topic // let topic: Topic
	let userInfo: UserInfo

	enum CodingKeys: String, CodingKey {
		case attendeesInfo = "attendeesInfo"
		case availableCapacity = "availableCapacity"
		case availableUserGuests = "availableUserGuests"
		case capacity = "capacity"
		case description = "description"
		case endDateString = "endDate"
		case eventId = "eventId"
		case fee = "fee"
		case format = "format"
		case guestCapacity = "guestCapacity"
		case guestPerMember = "guestPerMember"
		case guestsInfo = "guestsInfo"
		case happeningPhoto = "happeningPhoto"
		case hasWaitlist = "isWaitlisted"
		case location = "location"
		case rsvpOpenDateString = "rsvpOpenDate"
		case startDateString = "startDate"
		case title = "title"
		case topic = "topic"
		case userInfo = "userInfo"
	}
}
