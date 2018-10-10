//
//  Reachability.swift
//  TheWing
//
//  Created by Ruchi Jain on 8/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
 Copyright (c) 2014, Ashley Mills
 All rights reserved.
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 */

import SystemConfiguration
import Foundation

extension Notification.Name {
    
    // MARK: - Public Properties
    
    static let reachabilityChanged = Notification.Name("reachabilityChanged")
}

    // MARK: - Public Functions
    
/// Callback function for when SCNetworkReachability changed.
///
/// - Parameters:
///   - reachability: SCNetworkReachability reference.
///   - flags: Network reachability flags.
///   - info: Optional pointer.
func callback(reachability: SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) {
    guard let info = info else {
        return
    }
    
    let reachability = Unmanaged<Reachability>.fromOpaque(info).takeUnretainedValue()
    reachability.reachabilityChanged()
}

typealias NetworkReachable = (Reachability) -> Void

typealias NetworkUnreachable = (Reachability) -> Void

final class Reachability: ReachabilityProtocol {
    
    // MARK: - Public Properties
    
    // MARK: - Constants

    static let shared = Reachability(hostname: "api-stage.dev.thewing.prolific.io")
    
    /// Connection type.
    var connection: Connection {
        guard isReachableFlagSet else { return .none }
        
        // If we're reachable, but not on an iOS device (i.e. simulator), we must be on WiFi
        guard isRunningOnDevice else { return .wifi }
        
        var connection = Connection.none
        
        if !isConnectionRequiredFlagSet {
            connection = .wifi
        }
        
        if isConnectionOnTrafficOrDemandFlagSet {
            if !isInterventionRequiredFlagSet {
                connection = .wifi
            }
        }
        
        if isOnWWANFlagSet {
            if !allowsCellularConnection {
                connection = .none
            } else {
                connection = .cellular
            }
        }
        
        return connection
    }

    /// Date of the last status change.
    private(set) var lastReachibilityStatusChange: Date?
    
    // MARK: - Private Properties
    
    private let reachabilityRef: SCNetworkReachability
    
    private let reachabilitySerialQueue = DispatchQueue(label: "prolific.thewing")
    
    private var previousFlags: SCNetworkReachabilityFlags?
    
    private var isRunningOnDevice: Bool = {
        #if targetEnvironment(simulator)
        return false
        #else
        return true
        #endif
    }()

    private var notifierRunning = false
    
    private var usingHostname = false
    
    private var whenReachable: NetworkReachable?
    
    private var whenUnreachable: NetworkUnreachable?
    
    private var allowsCellularConnection: Bool
    
    private var notificationCenter: NotificationCenter = NotificationCenter.default
    
    // MARK: - Initialization
    
    /// Initializes a Reachability object with an SCNetworkReachability object.
    ///
    /// - Parameters:
    ///   - reachabilityRef: SCNetworkReachability reference.
    ///   - usingHostname: Boolean determining if Reachability should be instantiated with a hostname.
    required init(reachabilityRef: SCNetworkReachability, usingHostname: Bool = false) {
        allowsCellularConnection = true
        self.reachabilityRef = reachabilityRef
        self.usingHostname = usingHostname
    }
    
    /// Initializes a Reachability object given a hostname.
    ///
    /// - Parameter hostname: Hostname.
    convenience init?(hostname: String) {
        guard let ref = SCNetworkReachabilityCreateWithName(nil, hostname) else {
            return nil
        }
        self.init(reachabilityRef: ref, usingHostname: true)
    }
    
    /// Convenience initializer.
    convenience init?() {
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)
        
        guard let ref = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress) else {
            return nil
        }
        
        self.init(reachabilityRef: ref)
    }
    
    deinit {
        stopNotifier()
    }

    // MARK: - Public Functions
    
    /// Starts the ongoing process of checking network connectivity.
    ///
    /// - Throws: Error unable to set call back or unable to set dispatch queue.
    func startNotifier() throws {
        guard !notifierRunning else {
            return
        }
        
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged<Reachability>.passUnretained(self).toOpaque())
        if !SCNetworkReachabilitySetCallback(reachabilityRef, callback, &context) {
            stopNotifier()
            throw ReachabilityError.unableToSetCallback
        }
        
        if !SCNetworkReachabilitySetDispatchQueue(reachabilityRef, reachabilitySerialQueue) {
            stopNotifier()
            throw ReachabilityError.unableToSetDispatchQueue
        }
        
        // Perform an initial check
        reachabilitySerialQueue.async {
            self.reachabilityChanged()
        }
        
        notifierRunning = true
    }
    
    /// Stops the notifier.
    func stopNotifier() {
        defer { notifierRunning = false }
        
        SCNetworkReachabilitySetCallback(reachabilityRef, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachabilityRef, nil)
    }
    
}

// MARK: - Private Functions
private extension Reachability {
    
    var isOnWWANFlagSet: Bool {
        #if os(iOS)
        return flags.contains(.isWWAN)
        #else
        return false
        #endif
    }
    
    var isReachableFlagSet: Bool {
        return flags.contains(.reachable)
    }
    
    var isConnectionRequiredFlagSet: Bool {
        return flags.contains(.connectionRequired)
    }
    
    var isInterventionRequiredFlagSet: Bool {
        return flags.contains(.interventionRequired)
    }
    
    var isConnectionOnTrafficFlagSet: Bool {
        return flags.contains(.connectionOnTraffic)
    }
    
    var isConnectionOnDemandFlagSet: Bool {
        return flags.contains(.connectionOnDemand)
    }
    
    var isConnectionOnTrafficOrDemandFlagSet: Bool {
        return !flags.intersection([.connectionOnTraffic, .connectionOnDemand]).isEmpty
    }
    
    var isTransientConnectionFlagSet: Bool {
        return flags.contains(.transientConnection)
    }
    
    var isLocalAddressFlagSet: Bool {
        return flags.contains(.isLocalAddress)
    }
    
    var isDirectFlagSet: Bool {
        return flags.contains(.isDirect)
    }
    
    var isConnectionRequiredAndTransientFlagSet: Bool {
        return flags.intersection([.connectionRequired, .transientConnection]) == [.connectionRequired, .transientConnection]
    }
    
    var flags: SCNetworkReachabilityFlags {
        var flags = SCNetworkReachabilityFlags()
        if SCNetworkReachabilityGetFlags(reachabilityRef, &flags) {
            return flags
        } else {
            return SCNetworkReachabilityFlags()
        }
    }
    
    func reachabilityChanged() {
        guard previousFlags != flags else {
            return
        }
        
        let block = connection != .none ? whenReachable : whenUnreachable
        
        DispatchQueue.main.async {
            block?(self)
            self.lastReachibilityStatusChange = Date()
            self.notificationCenter.post(name: .reachabilityChanged, object: self)
        }
        
        previousFlags = flags
    }

}
