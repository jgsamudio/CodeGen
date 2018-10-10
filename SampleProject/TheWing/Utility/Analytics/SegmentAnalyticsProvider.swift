//
//  SegmentAnalyticsProvider.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/9/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Analytics
import Segment_Branch
import Segment_Appboy
import Keys

/// Segment analytics provider.
final class SegmentAnalyticsProvider: AnalyticsProvider, PushNotificationsProvider {
    
    // MARK: - Public Properties
    
    var launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    
	// MARK: - Initialization

    // MARK: - Initialization
    
    init(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        self.launchOptions = launchOptions
        start()
    }
    
	// MARK: - Public Functions

    // MARK: - Public Functions
    
    func start() {
        let configuration = SEGAnalyticsConfiguration(writeKey: TheWingKeys().segmentWriteKey)
        configuration.launchOptions = launchOptions
        configuration.trackApplicationLifecycleEvents = true
        configuration.use(BNCBranchIntegrationFactory.instance())
        configuration.use(SEGAppboyIntegrationFactory.instance())
        SEGAppboyIntegrationFactory.instance().saveLaunchOptions(launchOptions)
        SEGAnalytics.setup(with: configuration)
    }
    
    func identify(userId: String, userTraits: [String: Any]?) {
        SEGAnalytics.shared().identify(userId, traits: userTraits, options: nil)
    }
    
    func track(event: String, properties: [String: Any]?, options: [String: Any]?) {
        var mutableProperties = properties ?? [:]
        mutableProperties[AnalyticsConstants.platformKey] = AnalyticsConstants.iOS
        SEGAnalytics.shared().track(event, properties: mutableProperties, options: options)
    }
    
    func screen(screenTitle: String, properties: [String: Any]?, options: [String: Any]?) {
        var mutableProperties = properties ?? [:]
        mutableProperties[AnalyticsConstants.platformKey] = AnalyticsConstants.iOS
        SEGAnalytics.shared().screen(screenTitle, properties: mutableProperties, options: options)
    }
    
    func reset() {
        SEGAnalytics.shared().reset()
    }
    
    func didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: Data) {
        SEGAnalytics.shared().registeredForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any],
                                      fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Appboy.sharedInstance() == nil {
            SEGAppboyIntegrationFactory.instance().saveRemoteNotification(userInfo)
        }
        SEGAnalytics.shared().receivedRemoteNotification(userInfo)
        fetchCompletionHandler(.noData)
    }
    
}
