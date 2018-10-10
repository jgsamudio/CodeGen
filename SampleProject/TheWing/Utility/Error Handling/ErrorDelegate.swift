//
//  ErrorDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 8/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol ErrorDelegate: class {
    
    /// Notifies delegate that an error occurred and should be displayed.
    ///
    /// - Parameter error: Optional error to display.
    func displayError(_ error: Error?)
    
}
