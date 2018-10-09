//
//  CFTimer.swift
//  CrossFit Games
//
//  Created by Malinka S on 1/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Wraps Timer, which contains managing the timer functions
class CFTimer: NSObject {

    // MARK: - Private Properties
    
    private var timer: Timer!
    private var isTimerRunning: Bool = false
    private var interval: TimeInterval!
    private var repeats: Bool!

    // MARK: - Initialization
    
    init(interval: TimeInterval, repeats: Bool = false) {
        super.init()
        self.interval = interval
        self.repeats = repeats
    }

    // MARK: - Public Functions
    
    /// Creates a timer instance, if it isn't created yet
    /// based on the interval and the repeats values
    ///
    /// - Parameters:
    ///   - handler: Event handler
    ///   - target: Event target
    func start<T>(handler: Selector, target: T) where T: NSObject {
        if !isTimerRunning {
            timer = Timer.scheduledTimer(timeInterval: interval, target: target, selector: handler, userInfo: nil, repeats: repeats)
            isTimerRunning = true
        }
    }

    /// Invalidats the timer and sets to nil
    func invalidate() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        isTimerRunning = false
    }

}
