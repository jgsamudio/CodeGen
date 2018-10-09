//
//  FirebaseInstance.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 12/7/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation
import Firebase

/// Wrapper for firebase.
struct FirebaseInstance {

    // MARK: - Private Properties
    
    private static var onceToken = true

    // MARK: - Public Functions
    
    /// Sets up firebase if not done before.
    static func setupIfNeeded() {
        if onceToken {
            FirebaseApp.configure()
            onceToken = false
        }
    }

}
