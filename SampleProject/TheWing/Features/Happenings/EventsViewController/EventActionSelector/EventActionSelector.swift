//
//  EventActionSelector.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class EventActionSelector {

    // MARK: - Public Properties

    weak var delegate: EventActionSelectorDelegate?

    weak var bookmarkDelegate: EventBookmarkActionDelegate?

    // MARK: - Public Functions

    /// Handles the action when the user taps the rsvp / cancel / waitlist button on the event cell.
    ///
    /// - Parameters:
    ///   - status: Current status of the button.
    ///   - eventData: Cell event data.
    func actionButtonSelected(status: EventActionButtonSource, eventData: EventData) {
        if let eventModalType = status.eventModalType(fee: eventData.feeAmount) {
            delegate?.displayEventModal(type: eventModalType, eventData: eventData)
            return
        }

        switch status {
        case .rsvp, .waitlist:
            delegate?.rsvpForEvent(status: status)
        case .guest:
            delegate?.addGuestSelected(eventData: eventData)
        case .bookmark(let isBookmarked):
            bookmarkDelegate?.bookmarkEventSelected(isBookmarked: isBookmarked)
        default:
            return
        }
    }

}
