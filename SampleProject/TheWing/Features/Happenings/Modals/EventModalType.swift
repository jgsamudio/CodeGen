//
//  EventModalType.swift
//  TheWing
//
//  Created by Luna An on 5/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Event modal type.
///
/// - rsvp: RSVP.
/// - rsvpWithFee: RSVP with fee.
/// - cancelRSVP: Cancel RSVP.
/// - cancelWaitlist: Cancel Waitlist.
/// - upgradeMembership: Upgrade membership.
/// - feeExplanation: Fee explanation.
/// - waitlist: Waitlist.
enum EventModalType {
    case rsvp
    case rsvpWithFee
    case cancelRSVP
    case cancelWaitlist
    case upgradeMembership
    case feeExplanation
    case waitlist
    case waitlistWithFee
    
    // MARK: - Public Properties
    
    /// Title.
    var title: String {
        switch self {
        case .rsvp:
            return "EVENT_RSVP_TITLE".localized(comment: "You're Going!")
        case .rsvpWithFee, .waitlistWithFee:
            return "EVENT_WITH_FEE!_TITLE".localized(comment: "Event with Fee!")
        case .cancelRSVP, .cancelWaitlist:
            return "CANT_GO_TITLE".localized(comment: "Can't Go?")
        case .upgradeMembership:
            return "WANT_ACCESS_TITLE".localized(comment: "Want Access?")
        case .feeExplanation:
            return "EVENT_WITH_FEE_TITLE".localized(comment: "Event with Fee")
        case .waitlist:
            return "WAITLISTED_TITLE".localized(comment: "You’re on the Waitlist!")
        }
    }
    
    /// Top icon.
    var topIcon: UIImage {
        switch self {
        case .rsvp:
            return #imageLiteral(resourceName: "sparkles_icon")
        case .rsvpWithFee, .waitlistWithFee:
            return #imageLiteral(resourceName: "events_fee")
        case .cancelRSVP, .cancelWaitlist:
            return #imageLiteral(resourceName: "question_mark_icon")
        case .upgradeMembership:
            return #imageLiteral(resourceName: "open_lock_icon")
        case .feeExplanation:
            return #imageLiteral(resourceName: "events_fee")
        case .waitlist:
            return #imageLiteral(resourceName: "clock_icon")
        }
    }
    
    /// Modal card style.
    var modalCardStyle: ModalCardStyle {
        switch self {
        case .rsvp, .rsvpWithFee, .waitlist, .waitlistWithFee:
            return .right
        case .cancelRSVP, .cancelWaitlist:
            return .left
        case .upgradeMembership, .feeExplanation:
            return .center
        }
    }
    
    /// Modal description.
    var description: String? {
        switch self {
        case .upgradeMembership:
            return "UPGRADE_MEMBERSHIP_DESCRIPTION".localized(comment: "Upgrade membership description")
        case .feeExplanation:
            return "EVENT_WITH_FEE_DESCRIPTION".localized(comment: "Event with fee description")
        default:
            return nil
        }
    }
    
    /// Bottom modal description.
    var bottomModalDescription: String {
        switch self {
        case .rsvp:
            return "RSVP_ADD_GUESTS_TEXT".localized(comment: "RSVP add guests text")
        case .rsvpWithFee, .waitlistWithFee:
            return "EVENT_WITH_FEE_DESCRIPTION".localized(comment: "Event with fee description")
        case .cancelRSVP, .cancelWaitlist:
            return "RSVP_CANCELLATION_DESCRIPTION".localized(comment: "RSVP cancellation description")
        case .upgradeMembership:
            return "UPGRADE_MEMBERSHIP_TEXT".localized(comment: "Upgrade membership text")
        case .feeExplanation:
            return "EVENT_FEE_CANCELLATION".localized(comment: "Event fee cancellation text")
        case .waitlist:
            return "WAITLISTED_DESCRIPTION".localized(comment: "Waitlisted description")
        }
    }
    
    /// Insets associated with the description label.
    var descriptionInsets: UIEdgeInsets {
        let offset = ViewConstants.defaultGutter
        let topOffset: CGFloat = 8
        
        switch self {
        case .rsvp:
            return UIEdgeInsets(top: topOffset, left: 0, bottom: 24, right: 0)
        case .rsvpWithFee, .waitlistWithFee, .cancelRSVP, .cancelWaitlist:
            return UIEdgeInsets(top: -topOffset, left: 0, bottom: offset, right: 0)
        case .upgradeMembership:
            return UIEdgeInsets(top: topOffset, left: 0, bottom: offset, right: 0)
        case .feeExplanation, .waitlist:
            return .zero
        }
    }
    
    /// Badge associated with each modal type.
    var badge: UIImage? {
        switch self {
        case .rsvp:
            return #imageLiteral(resourceName: "going_badge")
        case .waitlist:
            return #imageLiteral(resourceName: "waitlisted_badge")
        default:
            return nil
        }
    }
    
    /// Bottom icon.
    var bottomIcon: UIImage? {
        switch self {
        case .rsvp, .rsvpWithFee, .waitlistWithFee:
            return #imageLiteral(resourceName: "sparkles_small")
        default:
            return nil
        }
    }
    
    /// Indicates if the type should display a calendar component.
    var canAddToCalendar: Bool {
        switch self {
        case .rsvp, .waitlist:
            return true
        default:
            return false
        }
    }

}
