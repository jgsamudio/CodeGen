//
//  AuthAPIError.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// API error for the authentication loader.
///
/// - noTokenReturned: Used when no token is returned and no error is returned.
enum AuthAPIError: String, Error {
    case noTokenReturned
    case invalidToken
}
