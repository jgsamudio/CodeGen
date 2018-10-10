//
//  PushNotificationsProvider.swift
//  TheWing
//
//  Created by Ruchi Jain on 8/31/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

protocol PushNotificationsProvider {
    
    /// Handler for when device did register for remote notifications.
    ///
    /// - Parameter deviceToken: Device token.
    func didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: Data)
    
    /// Handler for remote notification was received.
    ///
    /// - Parameters:
    ///   - userInfo: User info object.
    ///   - fetchCompletionHandler: Completion handler.
    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any],
                                      fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    
}
