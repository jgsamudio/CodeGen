//
//  EventDetailData.swift
//  TheWing
//
//  Created by Luna An on 5/10/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class EventDetailData: BaseEventData, EventData {
    
    // MARK: - Initialization

    override init(event: Event, bookmarkInfo: BookmarkInfo?, eventCache: EventLocalCache) {
        super.init(event: event, bookmarkInfo: bookmarkInfo, eventCache: eventCache)
        self.topicIconURL = URL(string: event.topic.topicImage.png3x)
    }
    
}
