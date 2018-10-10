//
//  SessionManager.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation
import KeychainAccess

/// Session manager for the wing application.
final class SessionManager {

	// MARK: - Public Properties

    // MARK: - Public Properties
    
    /// Authentication token of the current user.
    var authToken: String? {
        get {
            return keychainString(authTokenKeychainKey)
        }
        set(newAuthToken) {
            setKeychainString(authTokenKeychainKey, value: newAuthToken)
        }
    }

    /// Current user of the application.
    var user: User? {
        set {
            let encoder = JSONEncoder()
            UserDefaults.standard.set(try? encoder.encode(newValue), forKey: SessionManager.userKey)
        }
        get {
            let decoder = JSONDecoder()
            if let data = UserDefaults.standard.data(forKey: SessionManager.userKey) {
                return try? decoder.decode(User.self, from: data)
            } else {
                return nil
            }
        }
    }

    /// Flag to determine if the user is logged in.
    var isLoggedIn: Bool {
        return (authToken != nil) && (user != nil)
    }

    // MARK: - Private Properties

    private lazy var keychain: Keychain = {
        return Keychain(service: bundleIdentifer)
    }()

    private var bundleIdentifer: String {
        guard let identifier = Bundle.main.bundleIdentifier else {
            return "com.default"
        }
        return identifier
    }

    private var authTokenKeychainKey: String {
        return bundleIdentifer + ".authtoken"
    }

    // MARK: - Constants

    private static let userKey = "user"

    // MARK: - Initialization

    init() {
        loadStoredUser()
    }

	// MARK: - Public Functions

    // MARK: - Public Functions
    
    /// Log out the current user.
    func logOut() {
        user = nil
        authToken = nil
    }

}

// MARK: - Private Functions
private extension SessionManager {

    func loadStoredUser() {
        guard let data = UserDefaults.standard.object(forKey: SessionManager.userKey) as? Data else {
            return
        }
        let decoder = JSONDecoder()
        user = try? decoder.decode(User.self, from: data)
    }

    func keychainString(_ identifier: String) -> String? {
        do {
            return try keychain.getString(identifier)
        } catch {
            print("Keychain retrieval error.")
        }
        return nil
    }

    func setKeychainString(_ identifier: String, value: String?) {
        guard let value = value else {
            removeKeychainString(identifier)
            return
        }

        do {
            try keychain.set(value, key: identifier)
        } catch {
            print("Keychain set failed.")
        }
    }

    func removeKeychainString(_ identifier: String) {
        do {
            try keychain.remove(identifier)
        } catch {
            print("Keychain remove failed")
        }
    }

}
