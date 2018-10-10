//
//  OnboardingEditorViewController.swift
//  TheWing
//
//  Created by Paul Jones on 7/13/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OnboardingEditorContainerViewController: BuildableViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: OnboardingEditorContainerViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                               navigationOrientation: .horizontal,
                                                               options: nil)
    
    private lazy var pages = OnboardingPages(builder: builder, delegate: self)
    
    private var currentPage: OnboardingBaseEditorViewControllerType?
    
    // MARK: - Initialization
    
    init(builder: Builder, theme: Theme, delegate: OnboardingEditorContainerViewControllerDelegate) {
        self.delegate = delegate
        super.init(builder: builder, theme: theme)
        pageViewController.setViewControllers([pages.first], direction: .forward, animated: false, completion: nil)
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        view.backgroundColor = theme.colorTheme.invertTertiary
        pageViewController.didMove(toParentViewController: self)
        pageViewController.view.autoPinEdgesToSuperviewEdges()
        pageViewController.view.backgroundColor = colorTheme.invertPrimary
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Attempt to jump to the stage of your choosing, used by the top bar.
    ///
    /// - Parameter stage: What stage would you like to jump to?
    func attemptNavigation(to stage: OnboardingProgressStage) {
        if let viewController = pages[forStage: stage], let currentPage = currentPage {
            if viewController != currentPage {
                if let direction = pages.navigationDirectionForTransition(fromEditor: currentPage,
                                                                          toEditor: viewController) {
                    self.currentPage = viewController
                    pageViewController.setViewControllers([viewController],
                                                          direction: direction,
                                                          animated: true,
                                                          completion: nil)
                }
            }
        }
    }
    
}

// MARK: - OnboardingBaseEditorViewControllerDelegate
extension OnboardingEditorContainerViewController: OnboardingBaseEditorViewControllerDelegate {
    
    func editorViewController(viewController: OnboardingBaseEditorViewControllerType,
                              setProgressViewIsHidden isHidden: Bool,
                              collapse: Bool,
                              animated: Bool,
                              completion: (() -> Void)?) {
        delegate?.setProgressViewIsHidden(isHidden: isHidden, collapse: collapse, animated: animated, completion: completion)
    }
    
    func editorViewController(viewController: OnboardingBaseEditorViewControllerType,
                              updateStage stage: OnboardingProgressStage) {
        delegate?.update(stage: stage)
    }
    
    func updateProgress(onStep step: OnboardingProgressStep) {
        delegate?.updateProgress(onStep: step)
    }
    
    func goToNextStep(viewController: OnboardingBaseEditorViewControllerType) {
        if viewController == pages.first {
            analyticsProvider.track(event: AnalyticsEvents.Onboarding.started.analyticsIdentifier,
                                    properties: currentUser?.analyticsProperties,
                                    options: nil)
        }
        
        if let next = pages[after: viewController] {
            viewController.prepareForOutroAnimation()
            viewController.performOutroAnimation { [weak self] (_) in
                guard let strongSelf = self else { return }
                strongSelf.currentPage = next
                strongSelf.pageViewController.setViewControllers([next],
                                                                 direction: .forward,
                                                                 animated: true,
                                                                 completion: { [weak self] _ in
                                                                    guard let strongSelf = self else { return }
                                                                    strongSelf.pages.finished(with: viewController)
                })
            }
        }
    }
    
    func goToPreviousStep(viewController: OnboardingBaseEditorViewControllerType) {
        if let previous = pages[before: viewController] {
            currentPage = previous
            pageViewController.setViewControllers([previous], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    func done(viewController: OnboardingBaseEditorViewControllerType) {
        delegate?.done(viewController: self)
        analyticsProvider.track(event: AnalyticsEvents.Onboarding.completed.analyticsIdentifier,
                                properties: currentUser?.analyticsProperties,
                                options: nil)
    }
    
    func prepareProgressViewForAnimation(isIntro: Bool) {
        delegate?.prepareProgressViewForAnimation(isIntro: isIntro)
    }
    
    func performProgressViewAnimation(isIntro: Bool, with completion: @escaping (Bool) -> Void) {
        delegate?.performProgressViewAnimation(isIntro: isIntro, with: completion)
    }
    
}
