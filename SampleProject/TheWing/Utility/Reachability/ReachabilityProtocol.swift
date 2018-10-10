//
//  ReachabilityProtocol.swift
//  TheWing
//
//  Created by Jonathan Samudio on 9/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol ReachabilityProtocol {

    /// Current connection status.
    var connection: Connection { get }

    /// Date of the last status change.
    var lastReachibilityStatusChange: Date? { get }

    /// Starts the notifier.
    func startNotifier() throws

}
