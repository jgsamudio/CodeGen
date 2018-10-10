//
//  EventActionButtonSource.swift
//  TheWing
//
//  Created by Jonathan Samudio on 5/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// User event status.
///
/// - rsvp: Going or not going to an event.
/// - bookmark: Bookmarked or not bookmarked.
/// - guest: Attending guest or no attending guest.
/// - waitlist: Is waitlisted event or not.
/// - locked: Event locked.
enum EventActionButtonSource {
    case rsvp(isGoing: Bool)
    case bookmark(isBookmarked: Bool)
    case guest(attendingGuest: Bool)
    case waitlist(isWaitlisted: Bool)
    case locked

    // MARK: - Public Properties
    
    /// Title of the button.
    var buttonTitle: String? {
        switch self {
        case .rsvp(let isGoing):
            return isGoing ? "CANCEL_RSVP_TITLE".localized(comment: "Cancel Rsvp") : "RSVP_TITLE".localized(comment: "RSVP")
        case .bookmark(let isBookmarked):
            return isBookmarked ? "REMOVE_BOOKMARK_TITLE".localized(comment: "Remove Bookmark") :
                "BOOKMARK_TITLE".localized(comment: "Bookmark")
        case .guest(let attendingGuest):
            return attendingGuest ? "EDIT_GUESTS_TITLE".localized(comment: "Edit Guests") :
                "ADD_GUESTS_TITLE".localized(comment: "Add Guests")
        case .waitlist(let isWaitlisted):
            return isWaitlisted ? "CANCEL_WAITLIST".localized(comment: "Cancel Waitlist") :
                "WAITLIST_TITLE".localized(comment: "Waitlist")
        default:
            return nil
        }
    }
    
    /// Id of the source for comparison.
    var typeId: Int {
        switch self {
        case .rsvp:
            return 0
        case .bookmark:
            return 1
        case .guest:
            return 2
        case .waitlist:
            return 3
        case .locked:
            return 4
        }
    }

    /// Flag to determine if the user is going to the event.
    var rsvpGoing: Bool {
        switch self {
        case .rsvp(let isGoing):
            return isGoing
        default:
            return false
        }
    }
    
    /// Flag to determine if the user is on the waitlist for an event.
    var isWaitlisted: Bool {
        switch self {
        case .waitlist(let isWaitlisted):
            return isWaitlisted
        default:
            return false
        }
    }

    /// Title of quick action button.
    var smallButtonTitle: String? {
        switch self {
        case .rsvp(let isGoing):
            return isGoing ? "CANCEL_TITLE".localized(comment: "Cancel") : "RSVP_TITLE".localized(comment: "RSVP")
        case .waitlist(let isWaitlisted):
            return isWaitlisted ? "CANCEL_TITLE".localized(comment: "Cancel") :
                "WAITLIST_TITLE".localized(comment: "Waitlist")
        case .locked:
            // Used for accessibility only as the locked button does not need to display its title.
            return "ACCESSIBILITY_LOCKED_BUTTON_TITLE".localized(comment: "Locked button title for accessibility")
        default:
            return nil
        }
    }
    
    // MARK: - Public Functions
    
    /// Returns the button style associated with quick action button.
    ///
    /// - Parameter buttonStyleTheme: Button style theme.
    /// - Returns: Button style.
    func smallButtonStyle(buttonStyleTheme: ButtonStyleTheme) -> ButtonStyle? {
        switch self {
        case .rsvp(let isGoing):
            return isGoing ? buttonStyleTheme.smallCancelButtonStyle : buttonStyleTheme.smallRSVPButtonStyle
        case .waitlist(let isWaitlisted):
            return isWaitlisted ? buttonStyleTheme.smallCancelButtonStyle : buttonStyleTheme.smallWaitlistButtonStyle
        default:
            return nil
        }
    }
    
    /// Returns stylized button for each action type.
    ///
    /// - Parameter buttonStyleTheme: Button style theme.
    /// - Returns: Stylized Button.
    func button(buttonStyleTheme: ButtonStyleTheme) -> StylizedButton? {
        let button = StylizedButton(buttonStyle: buttonStyle(buttonStyleTheme: buttonStyleTheme))
        updateButtonStyle(button: button, buttonStyleTheme: buttonStyleTheme)
        return button
    }

    /// Updates the given stylized button.
    ///
    /// - Parameter button: Button to update.
    /// - Parameter buttonStyleTheme: Button style theme.
    func updateButtonStyle(button: StylizedButton, buttonStyleTheme: ButtonStyleTheme) {
        let title = buttonTitle?.uppercased()
        button.accessibilityLabel = buttonTitle
        button.buttonStyle = buttonStyle(buttonStyleTheme: buttonStyleTheme)
        
        switch self {
        case .bookmark(let isBookmarked):
            if isBookmarked, button.titleLabel?.text != nil {
                button.setDelayedAnimation {
                    button.animateTitle(title)
                }
                button.animateTitle("BOOKMARKED".localized(comment: "BOOKMARKED!").uppercased())
            } else {
                button.animateTitle(title)
            }
        default:
            button.setTitle(title)
        }
    }

    /// Event modal type associated with the event action button source.
    ///
    /// - Parameter event: Current event.
    /// - Returns: Event modal type for the status.
    func eventModalType(fee: Double?) -> EventModalType? {
        switch self {
        case .rsvp(let isGoing):
            if isGoing {
                return .cancelRSVP
            } else if let fee = fee, fee != 0 {
                return .rsvpWithFee
            } else {
                return nil
            }
        case .locked:
            return .upgradeMembership
        case .waitlist(let isWaitlisted):
            if isWaitlisted {
                return .cancelWaitlist
            } else if let fee = fee, fee != 0 {
                return .waitlistWithFee
            }
            return nil
        default:
            return nil
        }
    }

}

// MARK: - Private Functions
extension EventActionButtonSource {

    private func buttonStyle(buttonStyleTheme: ButtonStyleTheme) -> ButtonStyle? {
        switch self {
        case .rsvp(let isGoing):
            return isGoing ? buttonStyleTheme.quaternaryButtonStyle : buttonStyleTheme.primaryDarkButtonStyle
        case .bookmark:
            return buttonStyleTheme.primaryLightButtonStyle
        case .guest:
            return buttonStyleTheme.primaryLightButtonStyle
        case .waitlist(let isWaitlisted):
            return isWaitlisted ? buttonStyleTheme.quaternaryButtonStyle : buttonStyleTheme.quintaryButtonStyle
        case .locked:
            return nil
        }
    }
    
}
