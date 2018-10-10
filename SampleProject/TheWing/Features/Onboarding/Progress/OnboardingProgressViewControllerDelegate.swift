//
//  OnboardingProgressViewControllerDelegate.swift
//  TheWing
//
//  Created by Paul Jones on 8/9/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol OnboardingProgressViewControllerDelegate: class {
    
    /// The user selected a stage in the top bar.
    ///
    /// - Parameters:
    ///   - viewController: The view controller the user selected it from.
    ///   - stage: The stage the user selected, attempt to jump here.
    func onboardingProgressViewController(_ viewController: OnboardingProgressViewController,
                                          didSelectStage stage: OnboardingProgressStage)
    
}
