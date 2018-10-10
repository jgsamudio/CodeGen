//
//  ModalEventCellViewOptions.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

struct ModalEventCellViewOptions: EventCellViewOptions {
    
    // MARK: - Public Properties
    
    let showActionButton = false
    
    let showDate = true
    
    let showTopicType = false
    
    let showBookmark = false
    
    let showFormat = false
    
    let trailingOffset: CGFloat = -10
    
}
