//
//  AppDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 2/19/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

	// MARK: - Public Properties

    // MARK: - Public Properties
    
    var window: UIWindow?
    
    var applicationBuilder: ApplicationBuilder?
    
	// MARK: - Public Functions

    // MARK: - Public Functions
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        self.window = window
        applicationBuilder = ApplicationBuilder(in: window, launchOptions: launchOptions)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        return applicationBuilder?.branchProvider?.application(app, open: url, options: options) ?? true
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        return applicationBuilder?.branchProvider?.continueUserActivity(userActivity) ?? true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        applicationBuilder?.pushProvider?.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        applicationBuilder?.pushProvider?.didReceiveRemoteNotification(userInfo: userInfo,
                                                                       fetchCompletionHandler: completionHandler)
    }
    
}
