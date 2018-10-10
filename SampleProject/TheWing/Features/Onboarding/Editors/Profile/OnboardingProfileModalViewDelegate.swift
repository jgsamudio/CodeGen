//
//  OnboardingProfileModalViewDelegate.swift
//  TheWing
//
//  Created by Paul Jones on 7/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol OnboardingProfileModalViewDelegate: class {
    
    /// Called when it's time to dismiss the view
    ///
    /// - Parameter view: the view you should dismiss
    func onboardingProfileModalViewDidTouchUpInsideDismissButton(view: OnboardingProfileModalView)
    
}
