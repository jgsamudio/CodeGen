//
//  EventDetailShareableObject.swift
//  TheWing
//
//  Created by Luna An on 5/9/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class EventShareableObject: DeepLinkShareable {
    
    // MARK: - Public Properties

    var title: String {
        return eventData.title
    }
    
    var objectId: String {
        return eventData.eventId
    }
    
    var additionalInformation: [String: String] {
        return [DeepLinkKeys.edp.rawValue: eventData.eventId]
    }
    
    var canonicalUrl: String {
        return DeepLinkURLs.happenings + eventData.eventId
    }
    
    var contentDescription: String {
        return eventData.description
    }
    
    var fallbackURLString: String {
        return DeepLinkURLs.happenings
    }
    
    // MARK: - Private Properties

    private let eventData: EventData
    
    // MARK: - Initialization
    
    init(eventData: EventData) {
        self.eventData = eventData
    }
    
}
