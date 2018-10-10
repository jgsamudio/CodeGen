//
//  ReachabilityNotifierDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 9/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol ReachabilityNotifierDelegate: class {

    /// Notifies delegate that it should display a notification that network became unreachable.
    func networkUnreachable()

    /// Notifies delegate that it should hide any notification that network became unreachable.
    func networkReachable()

}

extension ReachabilityNotifierDelegate {

    // MARK: - Public Functions
    
    func networkUnreachable() {
        // Optional
    }

    func networkReachable() {
        // Optional
    }
    
}
