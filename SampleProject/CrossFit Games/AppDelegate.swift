//
//  AppDelegate.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/18/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import FacebookCore
import UIKit
import Simcoe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var isTimerRunning = false
    private var timer: CFTimer!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let rootController = RootViewBuilder().build()
        window?.rootViewController = rootController

        PushNotifications.shared.setup(application: application)
        HockeyIntegration.setup()
        HockeyIntegration.checkVersion()

        Simcoe.run(with: [FirebaseAnalyticsModule()])

        #if ALPHA || BETA || DEBUG
            InstabugIntegration.shared.prepare()
            DebugMenu.setup()
        #endif

        CrashlyticsIntegration.shared.setup()
        /// Creates a timer to refresh data in every 10 minutes
        timer = CFTimer(interval: 10 * 60, repeats: true)

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        /// FB event tracking for app launches
        NotificationCenter.default.post(name: NotificationName.appDidBecomeActive.name, object: nil)
        AppEventsLogger.activate(application)
        KillSwitchManager.checkApiStatusOnAppBecomingActive()
        timer.start(handler: #selector(handleTimer), target: self)
        if PushNotifications.shared.didPromptBefore {
            PushNotifications.shared.updateRepromptCondition()
            PushNotifications.shared.promptIfNeeded(leavingLandingPage: false)
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        timer.invalidate()
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        guard window == self.window else {
            return .all // youtube player
        }
        return .portrait
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        PushNotifications.shared.application(application,
                                             didReceiveRemoteNotification: userInfo)
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PushNotifications.shared.application(application,
                                             didReceiveRemoteNotification: userInfo,
                                             fetchCompletionHandler: completionHandler)
    }

    @objc private func handleTimer() {
        NotificationCenter.default.post(name: NotificationName.refreshData.name, object: nil)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }

}
