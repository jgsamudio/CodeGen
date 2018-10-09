//
//  Debouncer.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/22/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Debouncer to limit calls
class Debouncer {

    weak var timer: Timer?

    /// Triggers callback after last uninterrupted delay
    ///
    /// - Parameters:
    ///   - delay: Amount of Delay (seconds)
    ///   - callback: Closure to trigger
    func trigger(delay: Double, callback: @escaping (() -> Void)) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            callback()
        }
    }

}
