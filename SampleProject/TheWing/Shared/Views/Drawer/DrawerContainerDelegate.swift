//
//  DrawerContainerDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol DrawerContainerDelegate: class {

    /// Called when the status bar needs to be updated.
    func updateStatusBarStatus()
}
