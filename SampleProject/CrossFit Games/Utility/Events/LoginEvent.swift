//
//  LoginEvent.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/29/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Events that are being sent when a user logs in during a flow that requires the user to be logged in.
enum LoginEvent {
    case loginSucceeded
    case loginCancelled
}
