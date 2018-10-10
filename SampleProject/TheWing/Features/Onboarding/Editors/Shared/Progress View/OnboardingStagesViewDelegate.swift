//
//  OnboardingStagesViewDelegate.swift
//  TheWing
//
//  Created by Paul Jones on 8/9/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol OnboardingStagesViewDelegate: class {
    
    /// The user has selected a stage to jump to in this view.
    ///
    /// - Parameters:
    ///   - view: What view did the user select the stage in?
    ///   - stage: What stage in the view did the user select?
    func onboardingStagesView(_ view: OnboardingStagesView, didSelectStage stage: OnboardingProgressStage)
    
}
