//
//  OnboardingProgressViewDelegate.swift
//  TheWing
//
//  Created by Paul Jones on 8/9/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol OnboardingProgressViewDelegate: class {
    
    /// The user selected a stage and you should attempt to jump to it.
    ///
    /// - Parameters:
    ///   - view: What view is sending this message?
    ///   - stage: What stage is the user attempting to jump to?
    func onboardingProgressView(_ view: OnboardingProgressView, didSelectStage stage: OnboardingProgressStage)
    
}
