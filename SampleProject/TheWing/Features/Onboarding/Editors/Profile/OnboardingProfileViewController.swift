//
//  OnboardingProfileViewControllerExtension.swift
//  TheWing
//
//  Created by Paul Jones on 7/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Velar

final class OnboardingProfileViewController: ProfileViewController {

    // MARK: - Public Properties
    
    weak var delegate: OnboardingBaseEditorViewControllerDelegate?
    
    override var analyticsIdentifier: String {
        return AnalyticsScreen.onboardingProfile.analyticsIdentifier
    }
    
    // MARK: - Private Properties
    
    private lazy var dismissStylizedButton: StylizedButton = {
        let button = StylizedButton(buttonStyle: theme.buttonStyleTheme.primaryFloatingButtonStyle)
        button.set(height: ViewConstants.bottomButtonHeight)
        button.addTarget(self, action: #selector(done), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.isiPhoneXOrBigger ? 10 : 0, right: 0)
        button.setTitle(OnboardingLocalization.profileDismissButtonText.uppercased())
        return button
    }()
    
    private lazy var velarPresenter: VelarPresenter = {
        let velar =  VelarPresenterBuilder.build(designer: DefaultBackgroundOverlayDesigner(theme: theme))
        velar.delegate = self
        return velar
    }()
    
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.editorViewController(viewController: self,
                                       setProgressViewIsHidden: true,
                                       collapse: true,
                                       animated: true,
                                       completion: nil)
        presentOnboardingProfileModalView()
        UserDefaults.standard.completedOnboarding = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButtonIsHidden = true
        setupActionButton()
    }

}

// MARK: - Private Functions
private extension OnboardingProfileViewController {
    
    func setupActionButton() {
        view.addSubview(dismissStylizedButton)
        dismissStylizedButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        scrollViewBottomConstraint?.constant = -ViewConstants.bottomButtonHeight
    }
    
    func presentOnboardingProfileModalView() {
        let onboardingProfileModalView = OnboardingProfileModalView(theme: theme)
        onboardingProfileModalView.userImageUrl = viewModel.user?.profile.photoUrl
        onboardingProfileModalView.userFirstName = viewModel.user?.profile.name.first
        onboardingProfileModalView.delegate = self
        velarPresenter.show(view: onboardingProfileModalView, animate: true)
    }
    
}

// MARK: - OnboardingBaseEditable
extension OnboardingProfileViewController: OnboardingBaseEditable {
    
    var progressStep: OnboardingProgressStep? {
        return nil
    }
    
    @objc func goToNextStep() {
        delegate?.goToNextStep(viewController: self)
    }
    
    @objc func goToPreviousStep() {
        delegate?.goToPreviousStep(viewController: self)
    }
    
    @objc func done() {
        delegate?.done(viewController: self)
    }

    func prepareForIntroAnimation() {
        ()
    }
    
    func performIntroAnimation(with completion: @escaping (Bool) -> Void) {
        completion(false)
    }
    
    func prepareForOutroAnimation() {
        ()
    }
    
    func performOutroAnimation(with completion: @escaping (Bool) -> Void) {
        completion(false)
    }
    
    var analyticsProperties: [String: Any] {
        return [:]
    }

}

// MARK: - OnboardingProfileModalViewDelegate
extension OnboardingProfileViewController: OnboardingProfileModalViewDelegate {
    
    func onboardingProfileModalViewDidTouchUpInsideDismissButton(view: OnboardingProfileModalView) {
        velarPresenter.hide(animate: true)
    }
    
}

// MARK: - VelarPresenterDelegate
extension OnboardingProfileViewController: VelarPresenterDelegate {
    
    func didPresent() {
        view.accessibilityElementsHidden = true
    }
    
    func didDismiss() {
        view.accessibilityElementsHidden = false
    }
    
    func willPresent() {
        // This is optional.
    }
    
    func willDismiss() {
        // This is optional.
    }
    
}
