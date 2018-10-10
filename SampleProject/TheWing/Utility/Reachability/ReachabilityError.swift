//
//  ReachabilityError.swift
//  TheWing
//
//  Created by Ruchi Jain on 8/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Reachability-associated errors.
///
/// - failedToCreateWithAddress: Failed to create with address error.
/// - failedToCreateWithHostname: Failed to create with hostname error.
/// - unableToSetCallback: Unable to set callback error.
/// - unableToSetDispatchQueue: Unable to set dispatch queue error.
enum ReachabilityError: Error {
    case failedToCreateWithAddress(sockaddr_in)
    case failedToCreateWithHostname(String)
    case unableToSetCallback
    case unableToSetDispatchQueue
}
