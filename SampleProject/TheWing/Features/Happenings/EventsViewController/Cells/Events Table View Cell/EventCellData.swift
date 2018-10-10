//
//  EventCellData.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class EventCellData: BaseEventData, EventData {
    
    // MARK: - Public Properties
    
    let quickAction: EventActionButtonSource?

    let isLastEvent: Bool

    var eventModalType: EventModalType? {
        return quickAction?.eventModalType(fee: feeAmount)
    }

    // MARK: - Initialization
    
    init(event: Event, isLastEvent: Bool, bookmarkInfo: BookmarkInfo? = nil, eventCache: EventLocalCache) {
        self.quickAction = event.quickAction(eventCache: eventCache)
        self.isLastEvent = isLastEvent
        super.init(event: event, bookmarkInfo: bookmarkInfo, eventCache: eventCache)
    }

}
