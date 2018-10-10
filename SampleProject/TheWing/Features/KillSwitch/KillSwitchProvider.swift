//
//  KillSwitchProvider.swift
//  TheWing
//
//  Created by Jonathan Samudio on 9/5/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Bellerophon

final class KillSwitchProvider {

    // MARK: - Private Properties

    private let window: UIWindow
    private let theme: Theme

    private var error: APIError?

    private var backendError: BackendError? {
        guard let error = error else {
            return nil
        }

        switch error {
        case .backend(let error):
            return error
        default:
            return nil
        }
    }

    private var descriptionText: String {
        if apiInactive() {
            return KillSwitchLocalization.killSwitchDescriptionText
        } else if forceUpdate() {
            return KillSwitchLocalization.forceUpdateDescriptionText
        }
        return ""
    }

    private lazy var manager: BellerophonManager = {
    
    // MARK: - Public Properties
    
        let config = BellerophonConfig(window: window,
                                       killSwitchView: killSwitchView,
                                       forceUpdateView: forceUpdateView,
                                       delegate: self)
        return BellerophonManager(config: config)
    }()

    private lazy var killSwitchView = KillSwitchView(theme: theme)
    private lazy var forceUpdateView = ForceUpdateView(theme: theme)

    // MARK: - Constants

    fileprivate static let retryInterval: TimeInterval = 15

    // MARK: - Initialization

    init(window: UIWindow, theme: Theme) {
        self.window = window
        self.theme = theme
    }

    // MARK: - Public Functions

    /// Called when a network error is received.
    ///
    /// - Parameter error: Api error.
    func receivedError(_ error: APIError?) {
        self.error = error
        manager.checkAppStatus()
    }

}

// MARK: - BellerophonManagerDelegate
extension KillSwitchProvider: BellerophonManagerDelegate {

    func bellerophonStatus(_ manager: BellerophonManager, completion: @escaping (BellerophonObservable?, Error?) -> Void) {
        if apiInactive() {
            killSwitchView.setUserMessage(userMessage())
        } else if forceUpdate() {
            forceUpdateView.setUserMessage(userMessage())
        }
        completion(self, nil)
    }

}

// MARK: - BellerophonObservable
extension KillSwitchProvider: BellerophonObservable {

    func apiInactive() -> Bool {
        return backendError?.code == BusinessConstants.killSwitchErrorCode
    }

    func forceUpdate() -> Bool {
        return backendError?.code == BusinessConstants.forceUpgradeErrorCode
    }

    func retryInterval() -> TimeInterval {
        return KillSwitchProvider.retryInterval
    }

    func userMessage() -> String {
        guard let backendError = backendError else {
            return descriptionText
        }
        return backendError.message.isEmpty ? descriptionText : backendError.message
    }

    func setUserMessage(_ message: String) {
        // Optional Function.
    }

}
