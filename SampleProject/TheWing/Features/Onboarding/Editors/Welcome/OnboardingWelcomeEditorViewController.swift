//
//  OnboardingWelcomeEditorViewController.swift
//  TheWing
//
//  Created by Luna An on 7/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OnboardingWelcomeEditorViewController: OnboardingBaseEditorViewController {
    
    // MARK: - Public Properties
    
    /// Onboarding welcome editor view model.
    var viewModel: OnboardingWelcomeEditorViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    // MARK: - Private Properties

    private lazy var scrollView = UIScrollView()
    
    private lazy var topView = UIView()
    
    private lazy var nextButton = StylizedButton(buttonStyle: theme.buttonStyleTheme.primaryFloatingButtonStyle,
                                                 title: OnboardingLocalization.letsDoThisTitle.uppercased(),
                                                 titleEdgeInsets: UIEdgeInsets(bottom: UIScreen.isiPhoneXOrBigger ? 10 : 0))
    
    private lazy var wingLogoImageView = UIImageView(image: #imageLiteral(resourceName: "wing_logo_blue"), contentMode: .scaleAspectFit)
    
    private lazy var roseIconImageView = UIImageView(image: #imageLiteral(resourceName: "rose_icon"), contentMode: .scaleAspectFit)
    
    private lazy var wavyLineImageView = UIImageView(image: #imageLiteral(resourceName: "wavy_line"), contentMode: .scaleAspectFill)
    
    private lazy var shortWavyLineImageView = UIImageView(image: #imageLiteral(resourceName: "short_wavy_line"), contentMode: .scaleAspectFill)
    
    private lazy var nameLabel = UILabel(text: "\(viewModel.userName)!".uppercased(),
                                         using: textStyleTheme.displayExtraHuge,
                                         with: colorTheme.primary)
    
    private lazy var welcomeLabel = UILabel(text: OnboardingLocalization.welcomeText, using: textStyleTheme.script)
    
    private lazy var descriptionLabel = UILabel(text: OnboardingLocalization.welcomeBody,
                                                using: textStyleTheme.headline1,
                                                with: colorTheme.primary)
    
    private lazy var centerStackView = UIStackView(arrangedSubviews: [wavyLineImageView,
                                                                      UIView(dividerWithDimension: .height, constant: 33),
                                                                      welcomeLabel,
                                                                      nameLabel,
                                                                      UIView(dividerWithDimension: .height, constant: 33),
                                                                      shortWavyLineImageView,
                                                                      UIView(dividerWithDimension: .height, constant: 55),
                                                                      descriptionLabel],
                                                   axis: .vertical,
                                                   distribution: .fill,
                                                   alignment: .center)
    
    private var wingLogoImageViewLeftConstraint: NSLayoutConstraint?
    
    private var roseIconImageViewRightConstraint: NSLayoutConstraint?
    
    private var actionButtonBottomLayoutConstraint: NSLayoutConstraint?
    
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupAccessibility()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = centerStackView.frame.size
    }
    
    override func prepareForIntroAnimation() {
        actionButtonBottomLayoutConstraint?.constant = ViewConstants.bottomButtonHeight
        view.layoutIfNeeded()
    }
    
    override func performIntroAnimation(with completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: AnimationConstants.defaultDuration,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: [.curveEaseOut],
                           animations: {
                            self.actionButtonBottomLayoutConstraint?.constant = 0
                            self.view.layoutIfNeeded()
            }, completion: completion)
        }
    }
    
    override func performOutroAnimation(with completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: AnimationConstants.defaultDuration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: [.curveEaseOut],
                       animations: {
                        self.wingLogoImageViewLeftConstraint?.constant = -100
                        self.roseIconImageViewRightConstraint?.constant = 100
                        self.wavyLineImageView.alpha = 0
                        self.actionButtonBottomLayoutConstraint?.constant = ViewConstants.bottomButtonHeight
                        self.centerStackView.spacing = UIScreen.height
                        self.view.layoutIfNeeded()
        }, completion: completion)
    }

}

// MARK: - Private Functions
private extension OnboardingWelcomeEditorViewController {
    
    func setupDesign() {
        view.backgroundColor = colorTheme.invertPrimary

        setupNextButton()
        setupScrollView()
        setupTopView()
        setupRoseIconImageView()
        setupWingLogoImageView()
        setupCenterStackView()
        
        nameLabel.textAlignment = .center
        welcomeLabel.textAlignment = .center
        
        wavyLineImageView.autoMatchAspectRatio(withHeight: 3.8, andWidth: 310)
        shortWavyLineImageView.autoMatchAspectRatio(withHeight: 3.8, andWidth: 110)

        delegate?.editorViewController(viewController: self,
                                       setProgressViewIsHidden: true,
                                       collapse: true,
                                       animated: false,
                                       completion: nil)
    }
    
    func setupNextButton() {
        view.addSubview(nextButton)
        nextButton.accessibilityLabel = OnboardingLocalization.letsDoThisTitle
        nextButton.autoPinEdge(toSuperviewEdge: .left)
        nextButton.autoPinEdge(toSuperviewEdge: .right)
        actionButtonBottomLayoutConstraint = nextButton.autoPinEdge(toSuperviewEdge: .bottom)
        nextButton.set(height: ViewConstants.bottomButtonHeight)
        nextButton.addTarget(viewModel, action: #selector(viewModel.onboardingStarted), for: .touchUpInside)
    }

    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.contentInset = UIEdgeInsets(top: 2)
        scrollView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 140), excludingEdge: .bottom)
        scrollView.autoPinEdge(.bottom, to: .top, of: nextButton)
    }
    
    func setupTopView() {
        view.insertSubview(topView, aboveSubview: scrollView)
        topView.layer.shadowColor = theme.colorTheme.emphasisQuintary.cgColor
        topView.layer.shadowOffset = ViewConstants.navigationBarShadowOffset
        topView.layer.shadowRadius = ViewConstants.navigationBarShadowRadius
        topView.layer.shadowOpacity = 1
        topView.layer.masksToBounds = false
        topView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        topView.autoSetDimension(.height, toSize: 140)
        topView.backgroundColor = theme.colorTheme.invertPrimary
    }
    
    func setupRoseIconImageView() {
        view.insertSubview(roseIconImageView, aboveSubview: topView)
        roseIconImageView.autoMatchAspectRatio(withHeight: 44, andWidth: 17)
        roseIconImageView.autoSetDimension(.height, toSize: 44)
        roseIconImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 67)
        roseIconImageViewRightConstraint = roseIconImageView.autoPinEdge(toSuperviewEdge: .right,
                                                                         withInset: ViewConstants.defaultGutter)
    }
    
    func setupWingLogoImageView() {
        view.insertSubview(wingLogoImageView, aboveSubview: topView)
        wingLogoImageView.autoMatchAspectRatio(withHeight: 38, andWidth: 47)
        wingLogoImageView.autoSetDimension(.height, toSize: 38)
        wingLogoImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 67)
        wingLogoImageViewLeftConstraint = wingLogoImageView.autoPinEdge(toSuperviewEdge: .left,
                                                                        withInset: ViewConstants.defaultGutter)
    }
    
    func setupCenterStackView() {
        scrollView.addSubview(centerStackView)
        centerStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(left: ViewConstants.defaultGutter,
                                                                        right: ViewConstants.defaultGutter))
        centerStackView.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
    func setupAccessibility() {
        if let nameLabelText = nameLabel.text?.lowercased().capitalizingFirstLetter(),
            let welcomeLabelText = welcomeLabel.text,
            let descriptionLabelText = descriptionLabel.text {
            nameLabel.accessibilityLabel = "\(welcomeLabelText) \(nameLabelText) \(descriptionLabelText)"
            nameLabel.isAccessibilityElement = true
            welcomeLabel.isAccessibilityElement = false
            descriptionLabel.isAccessibilityElement = false
        }
        
        nextButton.accessibilityLabel = nextButton.titleLabel?.text?.lowercased().capitalizingFirstLetter()
    }
    
}

// MARK: - OnboardingWelcomeEditorViewDelegate
extension OnboardingWelcomeEditorViewController: OnboardingWelcomeEditorViewDelegate {
    
    func onboardingStarted() {
        goToNextStep()
    }
    
}

// MARK: - UIScrollViewDelegate
extension OnboardingWelcomeEditorViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topView.layer.shadowOpacity = scrollView.navigationShadowOpacity
    }
    
}

extension OnboardingWelcomeEditorViewController {
    
    override var analyticsIdentifier: String {
        return AnalyticsScreen.onboardingWelcome.analyticsIdentifier
    }
    
    override var analyticsProperties: [String: Any] {
        return [
            AnalyticsEvents.Onboarding.stepName: analyticsIdentifier,
            AnalyticsEvents.Onboarding.stepPreviouslyCompleted: true,
            AnalyticsEvents.Onboarding.stepUpdated: OnboardingAnalyticsUpdate.none.rawValue
        ]
    }
    
}
