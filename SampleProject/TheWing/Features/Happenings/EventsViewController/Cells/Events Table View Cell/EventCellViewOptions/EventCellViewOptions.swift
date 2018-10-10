//
//  EventCellViewOptions.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

protocol EventCellViewOptions {
    
    /// Shows the action button: rsvp, waitlist, etc.
    var showActionButton: Bool { get }
    
    /// Shows the date label.
    var showDate: Bool { get }
    
    /// Shows the topic and type label.
    var showTopicType: Bool { get }
    
    /// Shows the bookmark button.
    var showBookmark: Bool { get }
    
    /// Trailing offset of the cell view.
    var trailingOffset: CGFloat { get }
    
    /// Determines if cell should display format.
    var showFormat: Bool { get }
    
}

extension EventCellViewOptions {
    
    // MARK: - Public Properties
    
    var showFormat: Bool {
        return !UIScreen.isSmall
    }
    
}
