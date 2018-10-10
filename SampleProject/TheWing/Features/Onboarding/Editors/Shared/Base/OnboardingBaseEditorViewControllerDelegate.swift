//
//  OnboardingBaseEditorViewControllerDelegate.swift
//  TheWing
//
//  Created by Paul Jones on 7/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

protocol OnboardingBaseEditorViewControllerDelegate: class {
    
    /// Used to have the editor update the progress of whole onboarding process.
    ///
    /// - Parameters:
    ///   - viewController: Which view controller is updating the progress?
    ///   - stage: The onboarding stage to update.
    func editorViewController(viewController: OnboardingBaseEditorViewControllerType,
                              updateStage stage: OnboardingProgressStage)
    
    /// Used to hide or show the progress view, which can be animated or instant.
    ///
    /// - Parameters:
    ///   - viewController: what view controller is sending the message?
    ///   - isHidden: do you want it hidden?
    ///   - collapse: do you want to collapse the progress view?
    ///   - animated: do you want it animated?
    ///   - completion: what are you going to do when the animation is done?
    func editorViewController(viewController: OnboardingBaseEditorViewControllerType,
                              setProgressViewIsHidden isHidden: Bool,
                              collapse: Bool,
                              animated: Bool,
                              completion: (() -> Void)?)
    
    /// Updates progress bar with percentage.
    ///
    /// - Parameter step: Onboarding progress step to update.
    func updateProgress(onStep step: OnboardingProgressStep)
    
    /// You are now done with your step, and it's time to move on.
    ///
    /// - Parameter viewController: what view controller is sending the message?
    func goToNextStep(viewController: OnboardingBaseEditorViewControllerType)
    
    /// The user wants to go back to a previous step.
    ///
    /// - Parameter viewController: what view controller is sending the message?
    func goToPreviousStep(viewController: OnboardingBaseEditorViewControllerType)
    
    /// The user is done with the whole process, and it's time to dismiss.
    ///
    /// - Parameter viewController: what view controller is sending the message?
    func done(viewController: OnboardingBaseEditorViewControllerType)
    
    /// Prepares the progress view for animation.
    ///
    /// - Parameter isIntro: Is this the intro?
    func prepareProgressViewForAnimation(isIntro: Bool)
    
    /// Performs the progress view animation.
    ///
    /// - Parameters:
    ///   - isIntro: Is this the intro?
    func performProgressViewAnimation(isIntro: Bool, with completion: @escaping (Bool) -> Void)
}
