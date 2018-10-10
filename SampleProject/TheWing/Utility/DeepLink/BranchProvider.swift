//
//  BranchProvider.swift
//  TheWing
//
//  Created by Luna An on 5/3/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Branch

/// Branch.io provider.
final class BranchProvider {
    
    // MARK: - Private Properties

    private let deeplinkHandler: callbackWithParams
    
    private var latestDeeplinkData: [AnyHashable: Any]?
    
    // MARK: - Initialization
    
    /// Configures Branch.io upon launching.
    ///
    /// - Parameters:
    ///   - launchOptions: Launch options to pass.
    ///   - window: UIWindow instance.
    init(launchOptions: [UIApplicationLaunchOptionsKey: Any]?, deeplinkHandler: @escaping callbackWithParams) {
        self.deeplinkHandler = deeplinkHandler
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(branchDidStartSession(notification:)),
            name: NSNotification.Name.BranchDidStartSession,
            object: nil
        )
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(branchShouldResumeSession(notification:)),
                                               name: Notification.Name.EnteredMainTabBar,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Functions
    
    /// Handles open url.
    ///
    /// - Parameters:
    ///   - application: UIApplication.
    ///   - url: URL.
    ///   - options: UIApplicationOpenURLOptions.
    /// - Returns: True if handled successfully by Branch, false otherwise.
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        return Branch.getInstance().application(application, open: url, options: options)
    }
    
    /// Continues user activity.
    ///
    /// - Returns: True, if continuation, successful, false otherwise.
    func continueUserActivity(_ userActivity: NSUserActivity) -> Bool {
        return Branch.getInstance().continue(userActivity)
    }
    
}

// MARK: - Private Functions
private extension BranchProvider {
    
    @objc func branchDidStartSession(notification: Notification) {
        latestDeeplinkData = nil
        
        if let error = notification.userInfo?[BranchErrorKey] as? Error {
            deeplinkHandler(nil, error)
        } else if let properties = notification.userInfo?[BranchUniversalObjectKey] as? BranchUniversalObject {
            latestDeeplinkData = properties.contentMetadata.customMetadata as? [AnyHashable: Any]
            deeplinkHandler(latestDeeplinkData, nil)
        } else if let url = notification.userInfo?[BranchURLKey] as? URL {
    
    // MARK: - Public Properties
    
            let path = url.absoluteString.components(separatedBy: "://")
            if path.count > 1, !path[1].isEmpty {
                latestDeeplinkData = [DeepLinkKeys.clickedBranchLink.rawValue: false]
                latestDeeplinkData?[DeepLinkKeys.deeplinkPath.rawValue] = path[1]
                deeplinkHandler(latestDeeplinkData, nil)
            }
        } else {
            deeplinkHandler(nil, nil)
        }
    }
    
    @objc func branchShouldResumeSession(notification: Notification) {
        guard let data = latestDeeplinkData else {
            return
        }
        
        deeplinkHandler(data, nil)
        latestDeeplinkData = nil
    }
    
}

