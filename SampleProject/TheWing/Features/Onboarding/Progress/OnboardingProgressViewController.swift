//
//  OnboardingProgressViewController.swift
//  TheWing
//
//  Created by Paul Jones on 7/13/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OnboardingProgressViewController: BuildableViewController {
    
    // MARK: - Public Properties

    weak var delegate: OnboardingProgressViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private lazy var progressContainerView: OnboardingProgressView = {
        let view = OnboardingProgressView(theme: theme)
        view.delegate = self
        return view
    }()
    
    // MARK: - Public Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(progressContainerView)
        progressContainerView.autoPinEdgesToSuperviewEdges()
    }
    
    /// Updates the state of the onboarding stages view.
    ///
    /// - Parameter stage: Onboarding progress stage. (e.g. basics, aboutYou, asksAndOffers)
    func update(stage: OnboardingProgressStage) {
        progressContainerView.updateStagesView(stage: stage)
    }
    
    /// Updates the progress bar.
    ///
    /// - Parameter step: Onboarding progress step to get the progress percent from.
    func updateProgress(onStep step: OnboardingProgressStep) {
        progressContainerView.updateProgressBar(with: step.progress)
    }
    
    /// Prepares the progress container view, see protocol for more details.
    func prepareViewForAnimation(isIntro: Bool) {
        progressContainerView.prepareForAnimation(isIntro: isIntro)
    }
    
    /// Performs the animation progress container view, see protocol for more details.
    func performAnimation(isIntro: Bool, with completion: @escaping (Bool) -> Void) {
        progressContainerView.performAnimation(isIntro: isIntro, with: completion)
    }
    
}

// MARK: - OnboardingProgressViewDelegate
extension OnboardingProgressViewController: OnboardingProgressViewDelegate {
    
    func onboardingProgressView(_ view: OnboardingProgressView, didSelectStage stage: OnboardingProgressStage) {
        delegate?.onboardingProgressViewController(self, didSelectStage: stage)
    }
    
}
