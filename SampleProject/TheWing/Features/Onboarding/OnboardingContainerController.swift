//
//  OnboardingContainerController.swift
//  TheWing
//
//  Created by Paul Jones on 7/13/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OnboardingContainerController: BuildableViewController {
    
    // MARK: - Private Properties
    
    private lazy var progressView = UIView()
    private lazy var progressViewController: OnboardingProgressViewController = {
    
    // MARK: - Public Properties
    
        let viewController = builder.onboardingProgressViewController()
        viewController.delegate = self
        return viewController
    }()
    
    private lazy var editorView = UIView()
    private lazy var editorViewController = builder.onboardingEditorViewController(delegate: self)
    
    private lazy var mainStackView: UIStackView = {
        return UIStackView(arrangedSubviews: [progressView, editorView],
                           axis: .vertical,
                           distribution: .fill,
                           alignment: .fill)
    }()
    
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainStackView)
        setupEmbeddedViewControllers()
        setupConstraints()
        view.backgroundColor = colorTheme.invertPrimary
    }

}

// MARK: - Private Functions
private extension OnboardingContainerController {
    
    func setupEmbeddedViewControllers() {
        addChildViewController(progressViewController)
        progressView.addSubview(progressViewController.view)
        progressViewController.didMove(toParentViewController: self)
        
        addChildViewController(editorViewController)
        editorView.addSubview(editorViewController.view)
        editorViewController.didMove(toParentViewController: self)
    }
    
    func setupConstraints() {
        mainStackView.autoPinEdgesToSuperviewEdges()
        progressView.autoSetDimension(.height, toSize: 112)
        progressViewController.view.autoPinEdgesToSuperviewEdges()
        editorViewController.view.autoPinEdgesToSuperviewEdges()
    }
    
}

// MARK: - OnboardingProgressViewControllerDelegate
extension OnboardingContainerController: OnboardingProgressViewControllerDelegate {
    
    func onboardingProgressViewController(_ viewController: OnboardingProgressViewController,
                                          didSelectStage stage: OnboardingProgressStage) {
        editorViewController.attemptNavigation(to: stage)
    }
    
}

// MARK: - OnboardingEditorContainerViewControllerDelegate
extension OnboardingContainerController: OnboardingEditorContainerViewControllerDelegate {
    
    func update(stage: OnboardingProgressStage) {
        progressViewController.update(stage: stage)
    }
    
    func updateProgress(onStep step: OnboardingProgressStep) {
        progressViewController.updateProgress(onStep: step)
    }
    
    func done(viewController: OnboardingEditorContainerViewController) {
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController,
            let rootViewController = navigationController.viewControllers[0] as? RootViewController else {
            return
        }
        
        rootViewController.transitionToMainApp()
    }
    
    func prepareProgressViewForAnimation(isIntro: Bool) {
        progressViewController.prepareViewForAnimation(isIntro: isIntro)
    }
    
    func performProgressViewAnimation(isIntro: Bool, with completion: @escaping (Bool) -> Void) {
        progressViewController.performAnimation(isIntro: isIntro, with: completion)
    }
    
    func setProgressViewIsHidden(isHidden: Bool, collapse: Bool, animated: Bool, completion: (() -> Void)?) {
        DispatchQueue.main.async { // do not remove even though it looks pointless, see: https://stackoverflow.com/a/20973822
            UIView.animate(withDuration: animated ? AnimationConstants.defaultDuration : 0, animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.progressView.isHidden = collapse
                strongSelf.progressView.alpha = isHidden ? 0 : 1
            }, completion: { (_) in
                completion?()
            })
        }
    }

}
