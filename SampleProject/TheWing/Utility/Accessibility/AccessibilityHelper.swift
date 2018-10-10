//
//  AccessibilityHelper.swift
//  TheWing
//
//  Created by Harlan Kellaway on 4/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Accessibility helper.
struct AccessibilityHelper {
    
    // MARK: - Public Functions
    
    /// Notifies VoiceOver that a significant screen change occurred.
    ///
    /// - Parameter focusElement: UI element to focus on after screen change.
    static func notifySignificantScreenChange(focusOn focusElement: Any?) {
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, focusElement)
    }
    
}
