//
//  UserDataStore.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/20/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Consists of all the usr related operations
class UserDataStore {

    /// Keychain data store for persisting private information.
    ///
    /// - Note: Required for maintaining login state of a user.
    weak var keychainDataStore: KeychainDataStore?

    /// Temporary storage of the user instance while creating the account
    var createAccountUser: User?

    /// Detailed user information containing id, address, etc
    var detailedUser: DetailedUser? {
        get {
            do {
                return try (keychainDataStore?.data(for: .detailedUser)).flatMap({ (data) -> DetailedUser? in
                    return try PropertyListDecoder().decode(DetailedUser.self, from: data)
                })
            } catch {
                return nil
            }
        }
        set {
            do {
                if let data = try newValue.flatMap(PropertyListEncoder().encode) {
                    keychainDataStore?.set(data: data, for: .detailedUser)
                } else {
                    keychainDataStore?.deleteValue(for: .detailedUser)
                }
            } catch {
                keychainDataStore?.deleteValue(for: .detailedUser)
            }
        }
    }

    /// User Full Name
    var userFullname: String? {
        if let detailedUser = detailedUser {
            return detailedUser.name
        }
        return [createAccountUser?.firstName, createAccountUser?.lastName].flatMap ({ $0 }).joined(separator: " ")
    }

    /// User Email
    var userEmail: String? {
        return detailedUser?.email ?? createAccountUser?.email
    }

    /// Determines if user is logged in
    var isLoggedIn: Bool {
        return detailedUser != nil
    }

}
