//
//  OnboardingBaseEditorViewController.swift
//  TheWing
//
//  Created by Paul Jones on 7/13/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

class OnboardingBaseEditorViewController: BuildableViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: OnboardingBaseEditorViewControllerDelegate?
    
    /// What step does this view controller handle? Implement in subclass.
    var progressStep: OnboardingProgressStep? {
        return nil
    }
    
    // MARK: - Private Properties
    
    private var didFireOnAppear = false
    
    // MARK: - Initialization
    
    init(builder: Builder, theme: Theme, delegate: OnboardingBaseEditorViewControllerDelegate?) {
        self.delegate = delegate
        super.init(builder: builder, theme: theme)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareForIntroAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !didFireOnAppear {
            analyticsProvider.track(event: AnalyticsEvents.Onboarding.stepViewed.analyticsIdentifier,
                                    properties: analyticsProperties,
                                    options: nil)
            didFireOnAppear = true
        }
        
        performIntroAnimation(with: { _ in })
        if let progressStep = progressStep {
            delegate?.updateProgress(onStep: progressStep)
        }
    }

    /// Track step completed
    func trackStepCompleted() {
        analyticsProvider.track(event: AnalyticsEvents.Onboarding.stepCompleted.analyticsIdentifier,
                                properties: analyticsProperties,
                                options: nil)
    }

    @objc func goToNextStep() {
        trackStepCompleted()
        delegate?.goToNextStep(viewController: self)
    }
    
    func goToPreviousStep() {
        delegate?.goToPreviousStep(viewController: self)
    }
    
    func done() {
        delegate?.done(viewController: self)
    }
    
    func prepareForIntroAnimation() {
        () // optional
    }
    
    func performIntroAnimation(with completion: @escaping (Bool) -> Void) {
        completion(false)
    }
    
    func prepareForOutroAnimation() {
        () // optional
    }
    
    func performOutroAnimation(with completion: @escaping (Bool) -> Void) {
        completion(false)
    }

}

// MARK: - OnboardingBaseEditable
extension OnboardingBaseEditorViewController: OnboardingBaseEditable { }

// MARK: - AnalyticsIdentifiable
extension OnboardingBaseEditorViewController: AnalyticsIdentifiable {
    
    @objc var analyticsIdentifier: String {
        if let identifier = progressStep?.analyticsIdentifier {
            return identifier
        } else {
            assert(false, "must be implemented by subclass.")
            return ""
        }
    }
    
}

// MARK: - AnalyticsRepresentable
extension OnboardingBaseEditorViewController: AnalyticsRepresentable {
    
    @objc var analyticsProperties: [String: Any] {
        return [
            AnalyticsEvents.Onboarding.stepName: analyticsIdentifier,
            AnalyticsEvents.Onboarding.stepPreviouslyCompleted: false,
            AnalyticsEvents.Onboarding.stepUpdated: OnboardingAnalyticsUpdate.none.rawValue
        ]
    }
    
}
