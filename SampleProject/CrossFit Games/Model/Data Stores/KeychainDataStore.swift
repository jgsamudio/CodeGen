//
//  KeychainDataStore.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/16/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation
import KeychainAccess

/// Data store for direct interaction with the keychain.
final class KeychainDataStore {

    private let keychain: Keychain

    init() {
        keychain = Keychain(server: CFEnvironmentManager.shared.currentGeneralEnvironment.baseURL,
                            protocolType: ProtocolType.https)

        let userDefaultsManager = UserDefaultsManager.shared
        // Hard reset keychain when the app is opened for the first time after install, making sure
        // no data is accessible from previous installs.
        if userDefaultsManager.getValue(byKey: .firstRunToken) == nil {
            deleteAll()
            userDefaultsManager.setValue(withKey: .firstRunToken, value: true)
        }
    }

    /// Retrieves a value from the keychain (if possible).
    ///
    /// - Parameter key: Key whose value has to be stored.
    /// - Returns: Value to be saved for the keychain key.
    func value(for key: KeychainKey) -> String? {
        return (try? keychain.get(key.rawValue)) as? String
    }

    /// Retrieves a value from the keychain (if possible).
    ///
    /// - Parameter key: Key whose value has to be stored.
    /// - Returns: Value to be saved for the keychain key.
    func data(for key: KeychainKey) -> Data? {
        return (try? keychain.getData(key.rawValue)) as? Data
    }

    /// Sets the given value for the provided keychain key.
    ///
    /// - Parameters:
    ///   - value: Value to save.
    ///   - key: Dedicated keychain key.
    func set(value: String, for key: KeychainKey) {
        try? keychain.set(value, key: key.rawValue)
    }

    /// Sets the given value for the provided keychain key.
    ///
    /// - Parameters:
    ///   - data: Value to save.
    ///   - key: Dedicated keychain key.
    func set(data: Data, for key: KeychainKey) {
        try? keychain.set(data, key: key.rawValue)
    }

    /// Removes the saved value for the provided keychain key.
    ///
    /// - Parameter key: Keychain key whose value should be removed.
    func deleteValue(for key: KeychainKey) {
        try? keychain.remove(key.rawValue)
    }

    /// Deletes all stored values from the keychain.
    func deleteAll() {
        keychain.allKeys().forEach { (key) in
            try? keychain.remove(key)
        }
    }

}
