//
//  ListEventCellViewOptions.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

struct ListEventCellViewOptions: EventCellViewOptions {
    
    // MARK: - Public Properties
    
    let showActionButton = true
    
    let showDate = false
    
    let showTopicType = true
    
    let showBookmark: Bool
    
    let trailingOffset: CGFloat = ViewConstants.defaultEventCellTrailingOffset

    // MARK: - Initialization
    
    init(data: EventData? = nil) {
        if let data = data {
            showBookmark = data.showBookmark
        } else {
            showBookmark = true
        }
    }
    
}
