//
//  AuthError.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/27/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Represents all the possible auth error types
enum AuthError: Error {

    /// Error that arises if credentials are invalid.
    case credentialsInvalid

    /// Error that arises if the given account already exists.
    case accountExists

    /// Network error that arises if the user didn't save their client credentials for keeping them signed in.
    case noSavedCredentials

}
