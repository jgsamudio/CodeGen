//
//  OnboardingStageIntroViewController.swift
//  TheWing
//
//  Created by Paul Jones on 7/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OnboardingStageIntroViewController: OnboardingBaseEditorViewController {
    
    // MARK: - Public Properties
    
    override var analyticsIdentifier: String {
        return viewModel.analyticsIdentifier
    }
    
    override var analyticsProperties: [String: Any] {
        return [
            AnalyticsEvents.Onboarding.stepName: viewModel.analyticsIdentifier,
            AnalyticsEvents.Onboarding.stepPreviouslyCompleted: true,
            AnalyticsEvents.Onboarding.stepUpdated: OnboardingAnalyticsUpdate.none.rawValue
        ]
    }
    
    // MARK: - Private Properties
    
    private let viewModel: OnboardingStageIntroViewModel
    
    private lazy var titleCaptionLabel = UILabel(text: viewModel.titleCaptionLabelText,
                                                 using: textStyleTheme.headline4,
                                                 with: colorTheme.emphasisSecondary)
    
    private lazy var titleLabel = UILabel(text: viewModel.titleLabelText.uppercased(),
                                          using: textStyleTheme.displayHuge,
                                          with: colorTheme.primary)
    
    private lazy var bodyLabel = UILabel(text: viewModel.bodyLabelText,
                                         using: textStyleTheme.headline3.withRegularFont(),
                                         with: colorTheme.emphasisQuaternary)
    
    private lazy var dividerView = UIView(dividerWithSize: CGSize(width: 160, height: 1),
                                          backgroundColor: colorTheme.emphasisSecondary)
    
    private lazy var topWavyLineImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "wavy_line"))
        imageView.contentMode = .scaleAspectFill
        imageView.autoSetDimension(.height, toSize: 3.8)
        return imageView
    }()
    
    private lazy var bottomWavyLineImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "wavy_line"))
        imageView.contentMode = .scaleAspectFill
        imageView.autoSetDimension(.height, toSize: 3.8)
        return imageView
    }()
    
    private lazy var asksOffersDescriptionLabel = UILabel(text: OnboardingLocalization.introAsksOffersBodyLabelText,
                                                          using: textStyleTheme.headline3,
                                                          with: colorTheme.emphasisSecondary)
    
    private lazy var asksOffersIntroView = OnboardingStageIntroAsksOffersView(theme: theme)
    
    private lazy var  mainStackViewArrangedSubviews: [UIView] = {
        switch viewModel.stage {
        case .asksAndOffers:
            return [topWavyLineImageView,
                    UIView(verticalDividerWithConstant: 12),
                    asksOffersDescriptionLabel,
                    UIView(verticalDividerWithConstant: 14),
                    bottomWavyLineImageView,
                    UIView(verticalDividerWithConstant: 60),
                    titleCaptionLabel,
                    UIView(verticalDividerWithConstant: 9),
                    asksOffersIntroView]
        default:
            return [titleCaptionLabel,
                    UIView(verticalDividerWithConstant: 8),
                    titleLabel,
                    UIView(verticalDividerWithConstant: 12),
                    dividerView,
                    UIView(verticalDividerWithConstant: 16),
                    bodyLabel]
        }
    }()
    
    private lazy var accessibilityEligibleViews: [UIView] = [asksOffersDescriptionLabel,
                                                             titleCaptionLabel,
                                                             asksOffersIntroView,
                                                             titleLabel,
                                                             bodyLabel]
    
    private lazy var mainStackView = UIStackView(arrangedSubviews: mainStackViewArrangedSubviews,
                                                 axis: .vertical,
                                                 distribution: .fill,
                                                 alignment: .leading)
    
    private lazy var scrollView = UIScrollView(frame: .zero)
    
    private lazy var actionButton: StylizedButton = {
        let button = StylizedButton(buttonStyle: buttonStyleTheme.primaryFloatingButtonStyle)
        button.addTarget(self, action: #selector(goToNextStep), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.isiPhoneXOrBigger ? 10 : 0, right: 0)
        let buttonText = viewModel.buttonText
        button.setTitle(buttonText.uppercased())
        button.accessibilityLabel = buttonText
        return button
    }()
    
    private var mainStackHorizontalAlignmentConstraint: NSLayoutConstraint?
    
    private var actionButtonBottomConstraint: NSLayoutConstraint?
    
    private let askOffersIntroStackViewDefaultSpacing: CGFloat = 16
    
    private let spacingForStackViewAnimation: CGFloat = 36
    
    private var mainStackDefaultHorizontalConstant: CGFloat {
        return isAsksOffersIntro ? 48 : (0.18 * UIScreen.height)
    }
    
    private var isAsksOffersIntro: Bool {
        switch viewModel.stage {
        case .asksAndOffers:
            return true
        default:
            return false
        }
    }
    
    private var isBasics: Bool {
        switch viewModel.stage {
        case .basics:
            return true
        default:
            return false
        }
    }
    
    // MARK: - Initialization
    
    init(builder: Builder,
         theme: Theme,
         delegate: OnboardingBaseEditorViewControllerDelegate?,
         viewModel: OnboardingStageIntroViewModel) {
        self.viewModel = viewModel
        super.init(builder: builder, theme: theme, delegate: delegate)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupAccessibility()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var mainStackViewSize = mainStackView.frame.size
        mainStackViewSize.height += mainStackDefaultHorizontalConstant + ViewConstants.defaultGutter
        scrollView.contentSize = mainStackViewSize
    }
    
    override func prepareForIntroAnimation() {
        titleCaptionLabel.alpha = 0
        titleLabel.alpha = 0
        bodyLabel.alpha = 0
        dividerView.alpha = 0
        
        if isAsksOffersIntro {
            topWavyLineImageView.alpha = 0
            asksOffersDescriptionLabel.alpha = 0
            bottomWavyLineImageView.alpha = 0
            asksOffersIntroView.asksAlpha = 0
            asksOffersIntroView.offersAlpha = 0
            asksOffersIntroView.andAlpha = 0
            asksOffersIntroView.stackViewSpacing = (spacingForStackViewAnimation / 2) + askOffersIntroStackViewDefaultSpacing
            mainStackView.spacing = (spacingForStackViewAnimation / 2)
        } else {
            mainStackView.spacing = spacingForStackViewAnimation
        }
        
        if isBasics {
            delegate?.prepareProgressViewForAnimation(isIntro: true)
        }
        
        mainStackHorizontalAlignmentConstraint?.constant = 300 + mainStackDefaultHorizontalConstant
        actionButtonBottomConstraint?.constant = ViewConstants.bottomButtonHeight
        
        view.layoutIfNeeded()
    }
    
    override func performIntroAnimation(with completion: @escaping ((Bool) -> Void)) {
        if isBasics {
            if let delegate = delegate {
                delegate.performProgressViewAnimation(isIntro: true, with: { (_) in
                    self.performStageIntroAnimation(with: completion)
                })
            } else {
                assert(false, "Why is this delegate nil?")
                performStageIntroAnimation(with: completion)
            }
        } else {
            performStageIntroAnimation(with: completion)
        }
    }
    
}

// MARK: - Private Functions
private extension OnboardingStageIntroViewController {
    
    func setupDesign() {
        view.backgroundColor = theme.colorTheme.invertPrimary
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        scrollView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        mainStackView.autoPinEdge(toSuperviewEdge: .left, withInset: ViewConstants.defaultGutter)
        mainStackView.autoPinEdge(toSuperviewEdge: .right, withInset: ViewConstants.defaultGutter)
        mainStackHorizontalAlignmentConstraint = mainStackView.autoPinEdge(toSuperviewEdge: .top,
                                                                           withInset: mainStackDefaultHorizontalConstant)
        mainStackView.autoAlignAxis(.vertical, toSameAxisOf: scrollView)
        
        view.addSubview(actionButton)
        scrollView.autoPinEdge(.bottom, to: .top, of: actionButton)
        actionButton.isHidden = true
        actionButton.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        actionButton.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        actionButtonBottomConstraint = actionButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        actionButton.set(height: ViewConstants.bottomButtonHeight)
        delegate?.editorViewController(viewController: self,
                                       setProgressViewIsHidden: false,
                                       collapse: false,
                                       animated: true,
                                       completion: nil)
        delegate?.editorViewController(viewController: self,
                                       updateStage: viewModel.stage)
        if isAsksOffersIntro {
            asksOffersIntroView.autoMatch(.width, of: mainStackView)
        }
    }
    
    func setupAccessibility() {
        accessibilityEligibleViews.forEach({ $0.isAccessibilityElement = false })
        
        switch viewModel.stage {
        case .asksAndOffers:
            let elements = [asksOffersDescriptionLabel, titleCaptionLabel, asksOffersIntroView, actionButton]
            accessibilityElements = elements
            elements.forEach({ $0.isAccessibilityElement = true })
        default:
            let elements = [titleLabel, actionButton]
            accessibilityElements = elements
            elements.forEach({ $0.isAccessibilityElement = true })
            
            if let caption = titleCaptionLabel.text, let title = titleLabel.text?.lowercased(), let body = bodyLabel.text {
                titleLabel.accessibilityLabel = "\(caption) \(title). \(body)"
            }
        }
    }
    
    func performStageIntroAnimation(with completion: @escaping (Bool) -> Void) {
        let duration: TimeInterval = 0.7
        let delay: TimeInterval = 0
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: [.curveEaseOut],
                       animations: {
                        self.mainStackHorizontalAlignmentConstraint?.constant = self.mainStackDefaultHorizontalConstant
                        self.mainStackView.spacing = 0
                        
                        if self.isAsksOffersIntro {
                            self.asksOffersIntroView.stackViewSpacing = self.askOffersIntroStackViewDefaultSpacing
                        }
                        
                        self.view.layoutIfNeeded()
        }, completion: nil)
        
        if isAsksOffersIntro {
            UIView.animateKeyframes(withTotalDuration: duration, delay: delay, keyframes: [ {
                self.topWavyLineImageView.alpha = 1
            }, {
                self.asksOffersDescriptionLabel.alpha = 1
            }, {
                self.bottomWavyLineImageView.alpha = 1
            }, {
                self.titleCaptionLabel.alpha = 1
            }, {
                self.asksOffersIntroView.asksAlpha = 1
            }, {
                self.asksOffersIntroView.andAlpha = 1
            }, {
                self.asksOffersIntroView.offersAlpha = 1
            }, {
                self.bodyLabel.alpha = 1
            }], completion: { (_) in
                self.showBottomActionButtonAfterDelay(completion: completion)
            })
        } else {
            UIView.animateKeyframes(withTotalDuration: duration, delay: delay, keyframes: [ {
                self.titleCaptionLabel.alpha = 1
            }, {
                self.titleLabel.alpha = 1
                self.dividerView.alpha = 1
            }, {
                self.bodyLabel.alpha = 1
            }]) { (_) in
                self.showBottomActionButtonAfterDelay(completion: completion)
            }
        }
    }
    
    func showBottomActionButtonAfterDelay(completion: ((Bool) -> Void)?) {
        actionButton.isHidden = false
        UIView.animate(withDuration: 0.350,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: [.curveEaseOut],
                       animations: {
                        self.actionButtonBottomConstraint?.constant = 0
                        self.view.layoutIfNeeded()
        }, completion: completion)
    }
    
}
