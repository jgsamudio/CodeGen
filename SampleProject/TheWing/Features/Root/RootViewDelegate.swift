//
//  RootViewDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 2/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol RootViewDelegate: class {

    /// Transitions to the main app view controller.
    func transitionToMainApp()

    /// Transitions to login view controller.
    func transitionToLogin()
    
    /// Transitions to the onboarding view controller.
    func transitionToOnboarding()

}
