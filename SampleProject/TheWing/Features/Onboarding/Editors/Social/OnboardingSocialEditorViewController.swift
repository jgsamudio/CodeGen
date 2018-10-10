//
//  OnboardingSocialEditorViewController.swift
//  TheWing
//
//  Created by Paul Jones on 7/19/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Pilas

/// This view controller allows the user to add a website, twitter, facebook, and instagram fields to their profile
/// in onboarding.
final class OnboardingSocialEditorViewController: OnboardingBaseEditorViewController {

    // MARK: - Public Properties
    
    /// The view model for this view controller, setting this sets the delegate of this object and the subviews.
    var viewModel: OnboardingSocialEditorViewModel! {
        didSet {
            viewModel.delegate = self
            editSocialLinksView.delegate = viewModel
        }
    }
    
    override var progressStep: OnboardingProgressStep? {
        return .social
    }
    
    override var analyticsProperties: [String: Any] {
        return viewModel.analyticsProperties
    }
    
    // MARK: - Private Properties
    
    private lazy var buttonsView = OnboardingButtonsView(theme: theme, delegate: self, gutter: ViewConstants.defaultGutter)
    
    private lazy var editSocialLinksView = EditSocialLinksView(theme: theme, gutter: 0)
    
    private lazy var titleLabel = UILabel(text: OnboardingLocalization.socialTitleLabelText,
                                          using: textStyleTheme.headline1.withColor(colorTheme.primary).withEmFont())
    
    private lazy var mainStackViewArrangedSubviews = [titleLabel,
                                                      UIView.dividerView(height: 24),
                                                      editSocialLinksView]
    
    private lazy var mainStackView = UIStackView(arrangedSubviews: mainStackViewArrangedSubviews,
                                                 axis: .vertical,
                                                 distribution: .fill,
                                                 alignment: .fill)
    
    private lazy var scrollView = PilasScrollView(alignment: .fill, distribution: .fill, axis: .vertical)
    
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.insertView(view: mainStackView)
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        view.backgroundColor = theme.colorTheme.invertTertiary
        scrollView.autoPinEdgesToSuperviewEdges(with: ViewConstants.defaultInsets, excludingEdge: .top)
        scrollView.autoPinEdge(.top, to: .top, of: view, withOffset: 85)
        scrollView.enableKeyboardNotifications = true
        addRecognizerForKeyboardDismissal()
        view.addSubview(buttonsView)
        buttonsView.autoPinEdgesToSuperviewEdges(excludingEdge: .bottom)
        
        delegate?.editorViewController(viewController: self, updateStage: .basics(.inProgress))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
        viewModel.load()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    override func keyboardWillShow(notification: Notification) {
        buttonsView.isUserInteractionEnabled = false
    }
    
    override func keyboardWillHide(notification: Notification) {
        buttonsView.isUserInteractionEnabled = true
    }

}

// MARK: - OnboardingSocialEditorViewDelegate
extension OnboardingSocialEditorViewController: OnboardingSocialEditorViewDelegate {
    
    func setSaveShowing(_ showing: Bool) {
        buttonsView.showNextButton(show: showing)
    }
    
    func setSaveEnabled(_ enabled: Bool) {
        buttonsView.nextButtonIsEnabled = enabled
    }
    
    func isLoading(_ loading: Bool) {
        buttonsView.isLoading(loading)
    }
    
    func uploadCompleted(wasSuccessful success: Bool, withError error: Error?) {
        if success {
            goToNextStep()
        } else {
            presentAlertController(withNetworkError: error)
        }
    }
    
    func displaySocialLinksView(website: String?, instagram: String?, facebook: String?, twitter: String?) {
        editSocialLinksView.set(web: website, instagram: instagram, facebook: facebook, twitter: twitter)
    }
    
    func socialLinkValidityChanged(valid: Bool, socialType: SocialType) {
        guard !valid else {
            editSocialLinksView.hideError(in: socialType)
            return
        }
        
        editSocialLinksView.showError(in: socialType, errorMessage: socialType.localizedError)
    }
    
}

// MARK: - OnboardingButtonsViewDelegate
extension OnboardingSocialEditorViewController: OnboardingButtonsViewDelegate {
    
    func backButtonSelected() {
        goToPreviousStep()
    }
    
    func nextButtonSelected() {
        viewModel.upload()
    }
    
}

// MARK: - UIScrollViewDelegate
extension OnboardingSocialEditorViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        buttonsView.layer.shadowOpacity = scrollView.navigationShadowOpacity
    }
    
}
