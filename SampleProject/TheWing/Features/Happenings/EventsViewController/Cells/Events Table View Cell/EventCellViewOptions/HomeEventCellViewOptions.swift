//
//  HomeEventCellViewOptions.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

struct HomeEventCellViewOptions: EventCellViewOptions {
    
    // MARK: - Public Properties
    
    let showActionButton = true
    
    let showDate = true
    
    let showTopicType = true
    
    let showBookmark = true
    
    let trailingOffset: CGFloat = ViewConstants.defaultEventCellTrailingOffset
    
}
