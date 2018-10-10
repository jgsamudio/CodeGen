//
//  OnboardingButtonsView.swift
//  TheWing
//
//  Created by Luna An on 7/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OnboardingButtonsView: BuildableView {
    
    // MARK: - Public Properties

    /// Disable the next button, used for validation.
    var nextButtonIsEnabled: Bool {
        set {
            nextButton.isEnabled = newValue
            let textStyle = newValue ? buttonTextStyle : buttonTextStyleDisabled
            nextButton.setTitleText(OnboardingLocalization.nextButtonTitle, using: textStyle)
        }
        get {
            return nextButton.isEnabled
        }
    }
    
    // MARK: - Private Properties
    
    private weak var delegate: OnboardingButtonsViewDelegate?
        
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitleText(OnboardingLocalization.backButtonTitle, using: buttonTextStyle)
        button.isHidden = false
        button.addTarget(self, action: #selector(backButtonSelected), for: .touchUpInside)
        return button
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitleText(OnboardingLocalization.nextButtonTitle, using: buttonTextStyle)
        button.isHidden = true
        button.addTarget(self, action: #selector(nextButtonSelected), for: .touchUpInside)
        return button
    }()
    
    private lazy var loadingIndicator = LoadingIndicator(activityIndicatorViewStyle: .gray,
                                                         indicatorColor: theme.colorTheme.emphasisPrimary)
    
    // MARK: - Constants
    
    private lazy var buttonTextStyle = textStyleTheme.bodyNormal.withColor(colorTheme.emphasisPrimary)
    
    private lazy var buttonTextStyleDisabled = textStyleTheme.bodyNormal.withColor(colorTheme.emphasisQuintaryFaded)
    
    private var gutter: CGFloat

    // MARK: - Initialization
    
    init(theme: Theme, delegate: OnboardingButtonsViewDelegate?, gutter: CGFloat = ViewConstants.defaultGutter) {
        self.delegate = delegate
        self.gutter = gutter
        super.init(theme: theme)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Called when the back button is tapped.
    @objc func backButtonSelected() {
        delegate?.backButtonSelected()
    }
    
    /// Called when the next button is tapped.
    @objc func nextButtonSelected() {
        delegate?.nextButtonSelected()
    }
    
    /// Called to show or hide the next button.
    ///
    /// - Parameter show: Flag to determine to show/hide the button.
    func showNextButton(show: Bool) {
        nextButton.isHidden = !show
    }

    /// Called to indicate that the loading indicator is spinning.
    ///
    /// - Parameter loading: Loading state.
    func isLoading(_ loading: Bool) {
        nextButton.isHidden = loading
        loadingIndicator.isLoading(loading: loading)
    }
    
    /// Hides back button.
    func hideBackButton() {
        backButton.isHidden = true
    }
    
}

// MARK: - Private Functions
private extension OnboardingButtonsView {
    
    func setupView() {
        backgroundColor = theme.colorTheme.invertTertiary
        layer.shadowColor = theme.colorTheme.emphasisQuintary.cgColor
        layer.shadowOffset = ViewConstants.navigationBarShadowOffset
        layer.shadowRadius = ViewConstants.navigationBarShadowRadius
        layer.shadowOpacity = 0
        layer.masksToBounds = false
        clipsToBounds = false
        
        autoSetDimension(.height, toSize: 85)
        setupBackButton()
        setupNextButton()
        setupLoadingIndicator()
    }
    
    private func setupBackButton() {
        addSubview(backButton)
        backButton.autoPinEdge(.leading, to: .leading, of: self, withOffset: gutter)
        backButton.autoAlignAxis(toSuperviewAxis: .horizontal)
    }
    
    private func setupNextButton() {
        addSubview(nextButton)
        nextButton.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -gutter)
        nextButton.autoAlignAxis(toSuperviewAxis: .horizontal)
    }
    
    private func setupLoadingIndicator() {
        addSubview(loadingIndicator)
        loadingIndicator.autoAlignAxis(.horizontal, toSameAxisOf: nextButton)
        loadingIndicator.autoAlignAxis(.vertical, toSameAxisOf: nextButton)
        loadingIndicator.isLoading(loading: false)
    }

}

