//
//  PushNotifications.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 12/6/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation
import Firebase
import Simcoe
import UserNotifications

/// Push notification services.
final class PushNotifications: NSObject {

    // MARK: - Public Properties
    
    /// Shared instance for push notification handling.
    static let shared = PushNotifications()

    /// Indicates whether the user was prompted before.
    var didPromptBefore: Bool {
        return currentOpenCount > 0
    }

    // MARK: - Public Functions
    
    /// Indicates whether the user has allowed push notifications.
    func isPushEnabled(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            completion(settings.authorizationStatus == UNAuthorizationStatus.authorized)
        }
    }

    // MARK: - Initialization
    
    private override init() {
        super.init()
    }

    // MARK: - Private Properties
    
    private let openCountRepromptTriggers = [4]

    private var currentOpenCount: Int {
        get {
            return UserDefaultsManager.shared.getValue(byKey: .appOpenCount) as? Int ?? 0
        }
        set {
            UserDefaultsManager.shared.setValue(withKey: .appOpenCount, value: newValue)
        }
    }

    /// Sets up the app to receive push notifications.
    func setup(application: UIApplication) {
        FirebaseInstance.setupIfNeeded()

        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self
    }

    /// Updates the condition upon which the user gets reprompted to allow push notifications.
    func updateRepromptCondition() {
        currentOpenCount += 1
    }

    /// Prompt the user whether they want to receive push notifications.
    func promptIfNeeded(leavingLandingPage: Bool) {
        if leavingLandingPage && currentOpenCount == 1 || openCountRepromptTriggers.contains(currentOpenCount) {
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { [weak self] (settings) in
                switch settings.authorizationStatus {
                case .notDetermined:
                    self?.promptRequestForNotifications()
                default:
                    break
                }
            })
        }
    }

    /// Presents an alert controller that lets the user choose whether they want to receive push notifications before
    /// triggering the system library for the binding decision.
    func promptRequestForNotifications() {
        Simcoe.track(event: .pushOptInView,
                     withAdditionalProperties: [:], on: .pushOptIn)
        DispatchQueue.main.async {
            let localization = GeneralLocalization()
            let presentingViewController = UIViewController()
            presentingViewController.view.backgroundColor = .clear
            
            let prompt = UIAlertController(title: localization.pushTitle,
                                           message: localization.pushBody,
                                           preferredStyle: .alert)
            prompt.addAction(UIAlertAction(title: localization.pushDeny,
                                           style: .default,
                                           handler: { _ in
                                            presentingViewController.view.removeFromSuperview()
                                            Simcoe.track(event: .pushOptInExit,
                                                         withAdditionalProperties: [:], on: .pushOptIn)
            }))
            prompt.addAction(UIAlertAction(title: localization.pushAccept,
                                           style: .default,
                                           handler: { _ in
                                            presentingViewController.view.removeFromSuperview()
                                            UNUserNotificationCenter.current()
                                                .requestAuthorization(options: [.alert, .badge, .sound],
                                                                      completionHandler: {_, _ in
                                                                        Simcoe.track(event: .pushOptInSuccess,
                                                                                     withAdditionalProperties: [:], on: .pushOptIn)
                                                })
            }))
            
            let appWindow = UIApplication.shared.keyWindow
            appWindow?.addSubview(presentingViewController.view)
            presentingViewController.present(prompt, animated: true, completion: nil)
        }
    }

}

// MARK: - App Delegate functions
extension PushNotifications {

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {}

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.newData)
    }

}

// MARK: - MessagingDelegate
extension PushNotifications: MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {}

    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {}

}

// MARK: - UNUserNotificationCenterDelegate
extension PushNotifications: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound])
    }

}
