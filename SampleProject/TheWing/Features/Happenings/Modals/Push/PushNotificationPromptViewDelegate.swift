//
//  PushNotificationPromptViewDelegate.swift
//  TheWing
//
//  Created by Paul Jones on 8/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol PushNotificationPromptViewDelegate: class {
    
    /// The view did confirm that the push notification prompt was confirmed.
    ///
    /// - Parameter view: The view sending you the message.
    func pushNotificationPromptViewDidConfirm(_ view: PushNotificationPromptView)
    
}
