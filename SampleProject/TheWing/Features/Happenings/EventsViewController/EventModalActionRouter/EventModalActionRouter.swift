//
//  EventModalActionRouter.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation
import Velar

final class EventModalActionRouter {
    
    // MARK: - Public Properties
    
    weak var delegate: EventModalActionRouterDelegate?
    weak var viewController: BuildableViewController?
    
    let velarPresenter: VelarPresenter
    
    // MARK: - Initialization
    
    init(velarPresenter: VelarPresenter, viewController: BuildableViewController) {
        self.velarPresenter = velarPresenter
        self.viewController = viewController
        self.velarPresenter.delegate = self
    }
    
}

// MARK: - BaseModalCardDelegate
extension EventModalActionRouter: BaseModalCardDelegate {
    
    // MARK: - Public Functions
    
    func closeSelected(from modal: EventModal?) {
        velarPresenter.hide(animate: true)
        if modal?.type == .rsvp {
            delegate?.attemptToPresentPushPermission()
        }
    }
    
    func addGuestSelected(eventData: EventData) {
        velarPresenter.hide(animate: false)
        guard let viewController = viewController else {
            return
        }
        let controller = viewController.builder.editGuestsViewController(event: eventData, guestsDelegate: delegate)
        viewController.present(controller, animated: true, completion: nil)
    }
    
    func cancelRSVPSelected() {
        delegate?.cancelRsvpForEvent(from: .cancelRSVP)
        velarPresenter.hide(animate: true)
    }
    
    func cancelWaitlistSelected() {
        delegate?.cancelRsvpForEvent(from: .cancelWaitlist)
        velarPresenter.hide(animate: true)
    }
    
    func waitlistSelected() {
        velarPresenter.hide(animate: false)
        delegate?.trackWaitlistedFromErrorModal()
        delegate?.displayEventModal(type: .waitlist, eventData: nil)
    }
    
    func cancelSelected() {
        velarPresenter.hide(animate: true)
    }
    
    func confirmRSVPSelected() {
        velarPresenter.hide(animate: false)
        delegate?.rsvpForEvent(status: .rsvp(isGoing: false))
    }
    
    func composeMailSelected() {
        velarPresenter.hide(animate: true)
        guard let viewController = viewController else {
            return
        }

        let title = "UPGRADE_MEMBERSHIP_TITLE".localized(comment: "Upgrade Membership")
        viewController.presentEmailActionSheet(address: BusinessConstants.billingTeamEmailAddress, subject: title)
    }
    
    func joinWaitlistSelected() {
        velarPresenter.hide(animate: false)
        delegate?.rsvpForEvent(status: .waitlist(isWaitlisted: false))
    }
    
}

// MARK: - VelarPresenterDelegate
extension EventModalActionRouter: VelarPresenterDelegate {
    
    func didPresent() {
        viewController?.view.accessibilityElementsHidden = true
    }
    
    func didDismiss() {
        viewController?.view.accessibilityElementsHidden = false
    }
    
    func willPresent() {
        // This is optional.
    }
    
    func willDismiss() {
        // This is optional.
    }
    
}
