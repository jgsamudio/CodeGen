//
//  OnboardingProgressView.swift
//  TheWing
//
//  Created by Luna An on 7/13/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OnboardingProgressView: BuildableView {
    
    // MARK: - Public Properties
    
    weak var delegate: OnboardingProgressViewDelegate?
    
    // MARK: - Private Properties
    
    private lazy var onboardingStagesView: OnboardingStagesView = {
        let view = OnboardingStagesView(theme: theme)
        view.delegate = self
        return view
    }()
    
    private lazy var bottomBorder =  UIView.dividerView(height: 1, color: theme.colorTheme.tertiary)
    
    private lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.autoSetDimension(.height, toSize: 2)
        progressBar.trackTintColor = .clear
        progressBar.progressTintColor = theme.colorTheme.primary
        return progressBar
    }()
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions

    /// Updates onboarding stages view.
    ///
    /// - Parameter stage: Onboarding stage. ( e.g. basics, asksAndOffers, aboutYou )
    func updateStagesView(stage: OnboardingProgressStage) {
        onboardingStagesView.updateStageView(stage: stage)
    }
    
    /// Updates the progress bar.
    ///
    /// - Parameter progress: Progress to set - between 0 and 1.
    func updateProgressBar(with progress: Float) {
        progressBar.setProgress(progress, animated: true)
    }
    
    func prepareForAnimation(isIntro: Bool) {
        onboardingStagesView.prepareForAnimation(isIntro: isIntro)
        bottomBorder.alpha = isIntro ? 0 : 1
        progressBar.alpha = isIntro ? 0 : 1
    }
    
    func performAnimation(isIntro: Bool, with completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: AnimationConstants.defaultDuration, animations: {
            self.bottomBorder.alpha = isIntro ? 1 : 0
            self.progressBar.alpha = isIntro ? 1 : 0
        })
        onboardingStagesView.performAnimation(isIntro: isIntro, with: completion)
    }

}

// MARK: - Private Functions
private extension OnboardingProgressView {
    
    func setupView() {
        backgroundColor = theme.colorTheme.invertPrimary
        autoSetDimension(.height, toSize: 112)
        setupOnboardingStepView()
        setupBottomBorder()
        setupBottomProgressBar()
    }
    
    func setupOnboardingStepView() {
        addSubview(onboardingStagesView)
        onboardingStagesView.autoPinEdge(.top, to: .top, of: self, withOffset: 40)
        onboardingStagesView.autoPinEdge(.leading, to: .leading, of: self, withOffset: 48)
        onboardingStagesView.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -24)
    }
    
    func setupBottomBorder() {
        addSubview(bottomBorder)
        bottomBorder.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    func setupBottomProgressBar() {
        addSubview(progressBar)
        progressBar.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
 
}

// MARK: - OnboardingStagesViewDelegate
extension OnboardingProgressView: OnboardingStagesViewDelegate {
    
    func onboardingStagesView(_ view: OnboardingStagesView, didSelectStage stage: OnboardingProgressStage) {
        delegate?.onboardingProgressView(self, didSelectStage: stage)
    }
    
}
