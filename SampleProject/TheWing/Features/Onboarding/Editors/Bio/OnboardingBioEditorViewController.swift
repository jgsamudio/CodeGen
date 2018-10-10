//
//  OnboardingBioEditorViewController.swift
//  TheWing
//
//  Created by Paul Jones on 7/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import Pilas

final class OnboardingBioEditorViewController: OnboardingBaseEditorViewController {
    
    // MARK: - Public Properties
    
    var viewModel: OnboardingBioEditorViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override var progressStep: OnboardingProgressStep? {
        return .bio
    }
    
    override var analyticsProperties: [String: Any] {
        return viewModel.analyticsProperties
    }
    
    // MARK: - Private Properties
    
    private lazy var buttonsView = OnboardingButtonsView(theme: theme, delegate: self, gutter: ViewConstants.defaultGutter)
    
    private lazy var titleLabel = UILabel(text: OnboardingLocalization.bioTitleLabelText,
                                          using: textStyleTheme.headline1.withColor(colorTheme.primary).withEmFont())
    
    private lazy var exampleBackgroundView = UIView()
    
    private lazy var exampleTitleLabel = UILabel(text: OnboardingLocalization.exampleTitleLabelText.uppercased(),
                                                 using: theme.textStyleTheme.captionLarge.withStrongFont())
    
    private lazy var exampleBodyLabel = UILabel(text: OnboardingLocalization.bioExampleBodyText,
                                                using: theme.textStyleTheme.bodySmall)
    
    private lazy var exampleStackView = UIStackView(arrangedSubviews: [exampleTitleLabel, exampleBodyLabel],
                                                    axis: .vertical,
                                                    distribution: .fill,
                                                    alignment: .fill,
                                                    spacing: 15)
    
    private lazy var exampleLeftSpacerView = UIView(dividerWithDimension: .width,
                                                    constant: ViewConstants.defaultGutter)
    
    private lazy var exampleRightSpacerView = UIView(dividerWithDimension: .width,
                                                     constant: ViewConstants.defaultGutter)
    
    private lazy var exampleSpacedStackViewArrangedSubviews = [exampleLeftSpacerView,
                                                               exampleStackView,
                                                               exampleRightSpacerView]
    
    private lazy var exampleSpacedStackView = UIStackView(arrangedSubviews: exampleSpacedStackViewArrangedSubviews,
                                                          axis: .horizontal,
                                                          distribution: .fill,
                                                          alignment: .fill)
    
    private lazy var editBiographyView = EditBiographyView(theme: theme, delegate: viewModel, gutter: 0)
    
    private lazy var mainStackViewArrangedSubviews = [titleLabel,
                                                      UIView.dividerView(height: 16),
                                                      editBiographyView]
    
    private lazy var bioEditorStackView = UIStackView(arrangedSubviews: mainStackViewArrangedSubviews,
                                                      axis: .vertical,
                                                      distribution: .fill,
                                                      alignment: .fill)
    
    private lazy var bioEditorLeftSpacerView = UIView(dividerWithDimension: .width,
                                                      constant: ViewConstants.defaultGutter,
                                                      backgroundColor: theme.colorTheme.invertTertiary)
    
    private lazy var bioEditorRightSpacerView = UIView(dividerWithDimension: .width,
                                                       constant: ViewConstants.defaultGutter,
                                                       backgroundColor: theme.colorTheme.invertTertiary)
    
    private lazy var bioEditorSpacerStackViewArrangedSubviews = [bioEditorLeftSpacerView,
                                                                 bioEditorStackView,
                                                                 bioEditorRightSpacerView]
    
    private lazy var bioEditorSpacerStackView = UIStackView(arrangedSubviews: bioEditorSpacerStackViewArrangedSubviews,
                                                            axis: .horizontal,
                                                            distribution: .fill,
                                                            alignment: .fill)
    
    private lazy var bioEditorSpacerStackContainerView = UIView(containerWithSubview: bioEditorSpacerStackView,
                                                                backgroundColor: theme.colorTheme.invertTertiary)
    
    private lazy var scrollView = PilasScrollView(alignment: .fill, distribution: .fill, axis: .vertical)
    
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.loadBiography()
    }
    
}

// MARK: - Private Functions
private extension OnboardingBioEditorViewController {
  
    func setupViews() {
        view.backgroundColor = theme.colorTheme.invertSecondary
        bioEditorSpacerStackContainerView.autoMatch(.height, of: bioEditorSpacerStackView)
        setupScrollView()
        view.addSubview(buttonsView)
        buttonsView.autoPinEdgesToSuperviewEdges(excludingEdge: .bottom)
        buttonsView.showNextButton(show: true)
    }
    
    func setupScrollView() {
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.insertView(view: bioEditorSpacerStackContainerView)
        scrollView.insertDividerView(height: 30, width: nil, backgroundColor: theme.colorTheme.invertTertiary)
        scrollView.insertDividerView(height: 20, width: nil, backgroundColor: .clear)
        scrollView.insertView(view: exampleSpacedStackView)
        scrollView.insertDividerView(height: ViewConstants.defaultGutter, width: nil, backgroundColor: .clear)
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.autoPinEdgesToSuperviewEdges(excludingEdge: .top)
        scrollView.autoPinEdge(.top, to: .top, of: view, withOffset: 85)
        scrollView.enableKeyboardNotifications = true
        addRecognizerForKeyboardDismissal()
    }

}

// MARK: - OnboardingBioEditorViewDelegate
extension OnboardingBioEditorViewController: OnboardingBioEditorViewDelegate {
    
    func displayBiography(biography: String) {
        editBiographyView.set(biography)
    }
    
    func setNextButton(enabled: Bool) {
        buttonsView.nextButtonIsEnabled = enabled
    }
    
    func isLoading(loading: Bool) {
        buttonsView.isLoading(loading)
    }
    
    func biographyUpdated() {
        goToNextStep()
        viewModel.resetAnalyticsProperties()
    }
    
    func biographyUpdateFailed(with error: Error?) {
        presentAlertController(withNetworkError: error)
    }
    
}

// MARK: - OnboardingButtonsViewDelegate
extension OnboardingBioEditorViewController: OnboardingButtonsViewDelegate {
    
    func backButtonSelected() {
        goToPreviousStep()
    }
    
    func nextButtonSelected() {
        viewModel.uploadBiographyToProfile()
    }
    
}

// MARK: - UIScrollViewDelegate
extension OnboardingBioEditorViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        buttonsView.layer.shadowOpacity = scrollView.navigationShadowOpacity
    }
    
}
