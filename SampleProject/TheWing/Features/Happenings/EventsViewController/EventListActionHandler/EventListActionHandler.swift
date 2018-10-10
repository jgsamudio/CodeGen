//
//  EventListActionHandler.swift
//  TheWing
//
//  Created by Jonathan Samudio on 7/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Shared event list item action handler between the home page and the happenings page.
final class EventListActionHandler {
    
    // MARK: - Public Properties
    
    weak var delegate: EventListActionDelegate?
    
    var selectedEventCellData: EventData?
    
    // MARK: - Private Properties
    
    private var networkProvider: LoaderProvider?
    
    // MARK: - Initialization
    
    init(networkProvider: LoaderProvider?) {
        self.networkProvider = networkProvider
    }
    
}

// MARK: - EventModalActionRouterDelegate
extension EventListActionHandler: EventModalActionRouterDelegate {
    
    // MARK: - Public Functions
    
    func attemptToPresentPushPermission() {
        delegate?.attemptToPresentPushPermission()
    }
    
    func updatedGuests(_ guests: [Guest]?, eventId: String) {
        networkProvider?.eventsLoader.loadEvent(eventId: eventId, membersLimit: 0, completion: { [weak self] (result) in
            result.ifSuccess {
                self?.delegate?.eventStatusUpdated(event: result.value?.data)
            }
            result.ifFailure {
                self?.delegate?.showError(result.error)
            }
        })
    }
    
    func displayEventModal(type: EventModalType, eventData: EventData?) {
        guard let eventData = eventData else {
            return
        }
        
        delegate?.displayEventModal(data: EventModalData(eventData: eventData, type: type))
    }
    
    func cancelRsvpForEvent(from type: EventModalType) {
        guard let eventId = selectedEventCellData?.eventId, let eventData = selectedEventCellData else {
            return
        }
        
        delegate?.trackCancelAction(type: type, eventData: eventData)
        networkProvider?.eventsLoader.cancel(eventId: eventId) { [weak self] (result) in
            result.ifSuccess {
                self?.delegate?.eventStatusUpdated(event: result.value?.data)
            }
            result.ifFailure {
                self?.delegate?.showError(result.error)
            }
        }
    }
    
    func rsvpForEvent(status: EventActionButtonSource) {
        guard let eventData = selectedEventCellData else {
            return
        }
        
        delegate?.trackConfirmAction(eventData: eventData, action: status)
        networkProvider?.eventsLoader.register(eventId: eventData.eventId) { [weak self] (result) in
            result.ifSuccess {
                self?.delegate?.eventStatusUpdated(event: result.value?.data)
                guard let event = result.value?.data, let eventCache = self?.networkProvider?.eventLocalCache else {
                    return
                }
                let eventData = EventCellData(event: event, isLastEvent: false, eventCache: eventCache)
                
                if event.userInfo.going {
                    self?.delegate?.displayEventModal(data: EventModalData(eventData: eventData, type: .rsvp))
                } else if event.waitlisted {
                    self?.delegate?.displayEventModal(data: EventModalData(eventData: eventData, type: .waitlist))
                } else {
                    self?.delegate?.showError(nil)
                }
            }
            result.ifFailure {
                self?.delegate?.showError(result.error)
            }
        }
    }
    
    func trackWaitlistedFromErrorModal() {
        guard let eventData = selectedEventCellData else {
            return
        }
        delegate?.trackWaitlistErrorModal(eventData: eventData)
    }
    
}

// MARK: - EventActionSelectorDelegate
extension EventListActionHandler: EventActionSelectorDelegate {
    
    func addGuestSelected(eventData: EventData) {
        delegate?.addGuestSelected(eventData: eventData)
    }
    
}
