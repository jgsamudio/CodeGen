//
//  OnboardingBuilderExtensions.swift
//  TheWing
//
//  Created by Paul Jones on 7/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

extension Builder {
    
    // MARK: - Public Functions
    
    /// Returns an onboarding container view controller view controller.
    ///
    /// - Returns: OnboardingContainerController.
    func onboardingContainerViewController() -> OnboardingContainerController {
    
    // MARK: - Public Properties
    
        let viewController = OnboardingContainerController(builder: self, theme: theme)
        return viewController
    }
    
    /// Returns an onboarding editor view controller.
    ///
    /// - Parameter delegate: Onboarding editor view controller delegate.
    /// - Returns: OnboardingEditorViewController.
    func onboardingEditorViewController(delegate: OnboardingEditorContainerViewControllerDelegate) ->
        OnboardingEditorContainerViewController {
            let viewController = OnboardingEditorContainerViewController(builder: self, theme: theme, delegate: delegate)
            return viewController
    }
    
    /// Returns an onboarding progress view controller.
    ///
    /// - Returns: OnboardingProgressViewController.
    func onboardingProgressViewController() -> OnboardingProgressViewController {
        let viewController = OnboardingProgressViewController(builder: self, theme: theme)
        return viewController
    }
    
    /// Builds an onboarding welcome view controller.
    ///
    /// - Parameter delegate: Onboarding base editor view controller delegate.
    /// - Returns: OnboardingWelcomeViewController.
    func onboardingWelcomeViewController(delegate: OnboardingBaseEditorViewControllerDelegate?)
        -> OnboardingBaseEditorViewControllerType {
            let viewController = OnboardingWelcomeEditorViewController(builder: self, theme: theme, delegate: delegate)
            viewController.viewModel = OnboardingWelcomeEditorViewModel(dependencyProvider: dependencyProvider)
            return viewController
    }
    
    /// Builds an onboarding photo view controller.
    ///
    /// - Parameter delegate: Onboarding base editor view controller delegate.
    /// - Returns: OnboardingPhotoViewController.
    func onboardingPhotoViewController(delegate: OnboardingBaseEditorViewControllerDelegate?)
        -> OnboardingBaseEditorViewControllerType {
            let viewController = OnboardingPhotoEditorViewController(builder: self, theme: theme, delegate: delegate)
            viewController.viewModel = OnboardingPhotoEditorViewModel(dependencyProvider: dependencyProvider)
            return viewController
    }
    
    // Builds an occupation view controller.
    ///
    /// - Parameter delegate: Onboarding base editor view controller delegate.
    /// - Returns: OnboardingPhotoViewController.
    func onboardingOccupationViewController(delegate: OnboardingBaseEditorViewControllerDelegate?)
        -> OnboardingBaseEditorViewControllerType {
            let viewController = OnboardingOccupationEditorViewController(builder: self, theme: theme, delegate: delegate)
            viewController.viewModel = OnboardingOccupationEditorViewModel(dependencyProvider: dependencyProvider)
            return viewController
    }
    
    // Builds an onboarding industry view controller.
    ///
    /// - Returns: UIViewController.
    func onboardingIndustryViewController(delegate: OnboardingBaseEditorViewControllerDelegate?)
        -> OnboardingBaseEditorViewControllerType {
            let viewController = OnboardingIndustryEditorViewController(builder: self, theme: theme, delegate: delegate)
            viewController.viewModel = OnboardingIndustryEditorViewModel(dependencyProvider: dependencyProvider)
            return viewController
    }
    
    // Builds an onboarding neighborhood view controller.
    ///
    /// - Returns: UIViewController.
    func onboardingNeighborhoodViewController(delegate: OnboardingBaseEditorViewControllerDelegate?)
        -> OnboardingBaseEditorViewControllerType {
            let viewController = OnboardingNeighborhoodEditorViewController(builder: self, theme: theme, delegate: delegate)
            viewController.viewModel = OnboardingNeighborhoodEditorViewModel(dependencyProvider: dependencyProvider)
            return viewController
    }
    
    /// Builds an onboarding profile view controller.
    ///
    /// - Parameter delegate: nboarding base editor view controller delegate.
    /// - Returns: UIViewController of type OnboardingBaseEditorProtocol.
    func onboardingProfileViewController(delegate: OnboardingBaseEditorViewControllerDelegate?)
        -> OnboardingBaseEditorViewControllerType {
            let viewController = OnboardingProfileViewController(builder: self, theme: theme)
            viewController.delegate = delegate
            viewController.hidesBottomBarWhenPushed = true
            let userId = dependencyProvider.networkProvider.sessionManager.user?.userId ?? ""
            viewController.viewModel = ProfileViewModel(userId: userId,
                                                        dependencyProvider: dependencyProvider,
                                                        partialMemberInfo: nil)
            return viewController
    }
    
    /// Builds the onboarding social editor view controller for your use.
    ///
    /// - Parameter delegate: The delegate for the view controller
    /// - Returns: The view controller ready to present.
    func onboardingSocialViewController(delegate: OnboardingBaseEditorViewControllerDelegate?)
        -> OnboardingBaseEditorViewControllerType {
            let viewController = OnboardingSocialEditorViewController(builder: self, theme: theme, delegate: delegate)
            viewController.viewModel = OnboardingSocialEditorViewModel(dependencyProvider: dependencyProvider)
            return viewController
    }
    
    /// Get an onboarding completed stage view controller
    ///
    /// - Parameters:
    ///   - delegate: The delegate for the view controller
    ///   - stage: The stage which is completed
    /// - Returns: A view controller
    func onboardingStageCompletedViewController(delegate: OnboardingBaseEditorViewControllerDelegate?,
                                                stage: OnboardingProgressStage) -> OnboardingBaseEditorViewControllerType {
        let viewModel = OnboardingStageCompletedViewModel(stage: stage)
        return OnboardingStageCompletedViewController(builder: self, theme: theme, delegate: delegate, viewModel: viewModel)
    }
    
    /// Onboarding stage intro view controller
    ///
    /// - Parameters:
    ///   - delegate: The delegate for the view controller
    ///   - stage: The stage that the user just completed
    /// - Returns: The view controller
    func onboardingStageIntroViewController(delegate: OnboardingBaseEditorViewControllerDelegate?,
                                            stage: OnboardingProgressStage) -> OnboardingBaseEditorViewControllerType {
        let viewModel = OnboardingStageIntroViewModel(stage: stage)
        return OnboardingStageIntroViewController(builder: self, theme: theme, delegate: delegate, viewModel: viewModel)
    }
    
    /// Builds the onboarding bio editor view controller for your use.
    ///
    /// - Parameter delegate: The delegate for the view controller.
    /// - Returns: The view controller, ready to use.
    func onboardingBioEditorViewController(delegate: OnboardingBaseEditorViewControllerDelegate?)
        -> OnboardingBaseEditorViewControllerType {
            let viewController = OnboardingBioEditorViewController(builder: self, theme: theme, delegate: delegate)
            viewController.viewModel = OnboardingBioEditorViewModel(dependencyProvider: dependencyProvider)
            return viewController
    }
    
    /// Builds the onboarding tags editor view controller given profile tag type.
    ///
    /// - Parameters
    ///   - type: Onboarding profile tag type.
    ///   - delegate: Base editor view controller delegate.
    /// - Returns: UIViewController.
    func onboardingTagsEditorViewController(type: OnboardingProfileTagType,
                                            delegate: OnboardingBaseEditorViewControllerDelegate?)
        -> OnboardingBaseEditorViewControllerType {
            let viewController = OnboardingTagsEditorViewController(builder: self, theme: theme, delegate: delegate)
            viewController.viewModel = OnboardingTagsEditorViewModel(type: type, dependencyProvider: dependencyProvider)
            return viewController
    }
    
    /// Builds an onboarding photo view controller.
    ///
    /// - Parameter delegate: Onboarding base editor view controller delegate.
    /// - Returns: OnboardingPhotoViewController.
    func onboardingPhotoViewController(delegate: OnboardingBaseEditorViewControllerDelegate)
        -> OnboardingBaseEditorViewControllerType {
            let viewController = OnboardingPhotoEditorViewController(builder: self, theme: theme, delegate: delegate)
            viewController.viewModel = OnboardingPhotoEditorViewModel(dependencyProvider: dependencyProvider)
            return viewController
    }

}
