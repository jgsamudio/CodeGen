//
//  ReachabilityNotifier.swift
//  TheWing
//
//  Created by Jonathan Samudio on 9/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class ReachabilityNotifier {

    // MARK: - Public Properties

    weak var delegate: ReachabilityNotifierDelegate?

    // MARK: - Private Properties

    private let reachability: ReachabilityProtocol?

    // MARK: - Initialization

    init(delegate: ReachabilityNotifierDelegate?, reachability: ReachabilityProtocol? = Reachability.shared) {
        self.delegate = delegate
        self.reachability = reachability
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }

    // MARK: - Public Functions

    /// Subscribes to reachibility changes.
    func subscribeToReachabilityChanges() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(notification:)),
                                               name: .reachabilityChanged,
                                               object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            #if DEBUG
            print(error)
            #endif
        }
    }

    /// Checks if the reachability status should checked again. Will display snack bar if necessary.
    func checkReachabilityStatus() {
        if let reachability = reachability,
            BusinessConstants.reachabilityRefreshInterval.hasElapsed(since: reachability.lastReachibilityStatusChange) {
            updateReachabilityStatus(reachability)
        }
    }

}

// MARK: - Private Functions
private extension ReachabilityNotifier {

    @objc func reachabilityChanged(notification: Notification) {
        guard let reachability = notification.object as? ReachabilityProtocol else {
            return
        }
        updateReachabilityStatus(reachability)
    }

    func updateReachabilityStatus(_ reachability: ReachabilityProtocol) {
        switch reachability.connection {
        case .cellular, .wifi:
            delegate?.networkReachable()
        case .none:
            delegate?.networkUnreachable()
        }
    }

}
