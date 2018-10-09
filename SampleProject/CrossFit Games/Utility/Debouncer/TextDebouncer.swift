//
//  TextDebouncer.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/22/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Debounces based on delay and previous text
final class TextDebouncer: Debouncer {

    // MARK: - Private Properties
    
    fileprivate var previousText = ""

    // MARK: - Public Functions
    
    /// Triggers callback for Text based debouncers
    ///
    /// - Parameters:
    ///   - text: String to match against
    ///   - delay: Amount of Delay (seconds)
    ///   - callback: Closure to trigger
    func trigger(text: String, delay: Double, callback: @escaping (() -> Void)) {
        if previousText == text {
            timer?.invalidate()
        } else {
    
    // MARK: - Public Properties
    
            let callbackWrapper = {
                self.previousText = text
                callback()
            }
            trigger(delay: delay, callback: callbackWrapper)
        }
    }

    /// Resets internal TextDebouncer
    func reset() {
        timer?.invalidate()
        previousText = ""
    }
    
}
