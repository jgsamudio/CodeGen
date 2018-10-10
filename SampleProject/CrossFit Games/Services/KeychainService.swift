//
//  KeychainService.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/15/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation
import KeychainAccess

/// Service for interacting with the secure keychain.
struct KeychainService {

    // MARK: - Private Properties
    
    /// Keychain data store to interact with.
    private let keychainDataStore: KeychainDataStore

    // MARK: - Initialization
    
    init(keychainDataStore: KeychainDataStore) {
        self.keychainDataStore = keychainDataStore
    }

    // MARK: - Public Functions
    
    /// Retrieves a value from the keychain (if possible).
    ///
    /// - Parameter key: Key whose value has to be stored.
    /// - Returns: Value to be saved for the keychain key.
    func value(for key: KeychainKey) -> String? {
        return keychainDataStore.value(for: key)
    }

    /// Sets the given value for the provided keychain key.
    ///
    /// - Parameters:
    ///   - value: Value to save.
    ///   - key: Dedicated keychain key.
    func set(value: String, for key: KeychainKey) {
        keychainDataStore.set(value: value, for: key)
    }

    /// Removes the saved value for the provided keychain key.
    ///
    /// - Parameter key: Keychain key whose value should be removed.
    func deleteValue(for key: KeychainKey) {
        keychainDataStore.deleteValue(for: key)
    }

}
