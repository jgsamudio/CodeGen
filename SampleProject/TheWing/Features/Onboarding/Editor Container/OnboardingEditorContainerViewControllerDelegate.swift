//
//  OnboardingEditorContainerViewControllerDelegate.swift
//  TheWing
//
//  Created by Paul Jones on 7/13/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol OnboardingEditorContainerViewControllerDelegate: class {
    
    /// Time to dismiss the whole thing.
    ///
    /// - Parameter viewController: what view controller is sending the message?
    func done(viewController: OnboardingEditorContainerViewController)
    
    /// Used to hide or show the progress view, which can be animated or instant.
    ///
    /// - Parameters:
    ///   - isHidden: do you want it hidden?
    ///   - collapse: do you want it to not take up top space?
    ///   - animated: do you want it animated?
    ///   - completion: what are you going to do when the animation is done?
    func setProgressViewIsHidden(isHidden: Bool, collapse: Bool, animated: Bool, completion: (() -> Void)?)
    
    /// Prepares the progress view for an animation.
    ///
    /// - Parameter isIntro: is this the intro animation or the outro?
    func prepareProgressViewForAnimation(isIntro: Bool)
    
    /// Performs the progress view animation.
    ///
    /// - Parameters:
    ///   - isIntro: is this the intro?
    func performProgressViewAnimation(isIntro: Bool, with completion: @escaping (Bool) -> Void)
    
    /// Update the onboarding stage.
    ///
    /// - Parameter stage: Onboarding progress stage.
    func update(stage: OnboardingProgressStage)
    
    /// Update progress bar.
    ///
    /// - Parameter step: Onboarding progress step to get the progress percent from.
    func updateProgress(onStep step: OnboardingProgressStep)
    
}
