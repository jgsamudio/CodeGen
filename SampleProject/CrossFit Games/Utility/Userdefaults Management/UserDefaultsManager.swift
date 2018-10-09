//
//  UserDefaultsManager.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/21/17.
//  Copyright © Prolific Interactive. All rights reserved.
//

import UIKit

/// Manages all the user defaults activities
/// Setting values and reading the values by a key
class UserDefaultsManager: NSObject {

    var defaults: UserDefaults

    static let shared = UserDefaultsManager()

    private override init() {
        defaults = UserDefaults.standard
    }

    func setValue(withKey key: UserDefaultsKey, value: Any?) {
        defaults.set(value, forKey: key.rawValue)
    }

    func getValue(byKey key: UserDefaultsKey) -> Any? {
        return defaults.value(forKeyPath: key.rawValue)
    }

    func getData(byKey key: UserDefaultsKey) -> Data? {
        return defaults.data(forKey: key.rawValue)
    }

}
