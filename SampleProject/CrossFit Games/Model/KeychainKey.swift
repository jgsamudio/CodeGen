//
//  KeychainKey.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/15/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Keys for saving and retrieving values to/from a keychain service.
enum KeychainKey: String {

    /// Username used for logging a user in.
    case username

    /// Password used for logging a user in.
    case password

    /// Detailed user information downloaded from API.
    case detailedUser

}
