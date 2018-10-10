//
//  OnboardingStageCompletedViewController.swift
//  TheWing
//
//  Created by Paul Jones on 7/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OnboardingStageCompletedViewController: OnboardingBaseEditorViewController {
    
    // MARK: - Public Properties

    override var analyticsIdentifier: String {
        return viewModel.analyticsIdentifier
    }
    
    override var analyticsProperties: [String: Any] {
        return [
            AnalyticsEvents.Onboarding.stepName: analyticsIdentifier,
            AnalyticsEvents.Onboarding.stepPreviouslyCompleted: true,
            AnalyticsEvents.Onboarding.stepUpdated: OnboardingAnalyticsUpdate.none.rawValue
        ]
    }
    
    // MARK: - Private Properties

    private var viewModel: OnboardingStageCompletedViewModel
    
    private lazy var checkmarkImageView = UIImageView(image: #imageLiteral(resourceName: "blue_circle_completed"))
    
    private lazy var titleLabel = UILabel(text: viewModel.titleLabelText.uppercased(),
                                          using: textStyleTheme.displayHuge,
                                          with: colorTheme.primary)
    
    private lazy var bodyLabel = UILabel(text: viewModel.bodyLabelText.uppercased(),
                                         using: textStyleTheme.displayHuge,
                                         with: colorTheme.emphasisSecondary)
    
    private lazy var dividerView = UIView(dividerWithSize: CGSize(width: 160, height: 1),
                                          backgroundColor: colorTheme.emphasisSecondary)
    
    private lazy var mainStackViewArrangedSubviews = [checkmarkImageView,
                                                      UIView(verticalDividerWithConstant: 24),
                                                      titleLabel,
                                                      UIView(verticalDividerWithConstant: 16),
                                                      dividerView,
                                                      UIView(verticalDividerWithConstant: 23),
                                                      bodyLabel]
    
    private lazy var mainStackView = UIStackView(arrangedSubviews: mainStackViewArrangedSubviews,
                                                 axis: .vertical,
                                                 distribution: .fill,
                                                 alignment: .leading)
    
    private var mainStackTopConstraint: NSLayoutConstraint?
    
    private let mainStackTopConstraintConstant = (0.15 * UIScreen.height)
    
    // MARK: - Initialization

    init(builder: Builder,
         theme: Theme,
         delegate: OnboardingBaseEditorViewControllerDelegate?,
         viewModel: OnboardingStageCompletedViewModel) {
        self.viewModel = viewModel
        super.init(builder: builder, theme: theme, delegate: delegate)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainStackView)
        view.backgroundColor = theme.colorTheme.invertPrimary
        checkmarkImageView.autoSetDimensions(to: CGSize(width: 48, height: 48))
        mainStackView.autoPinEdge(toSuperviewEdge: .leading, withInset: ViewConstants.defaultGutter)
        mainStackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: ViewConstants.defaultGutter)
        delegate?.editorViewController(viewController: self, updateStage: viewModel.stage)
        
        mainStackTopConstraint = mainStackView.autoPinEdge(toSuperviewEdge: .top, withInset: mainStackTopConstraintConstant)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.progressViewShouldBeHidden {
            delegate?.prepareProgressViewForAnimation(isIntro: false)
        }
    }
    
    override func prepareForIntroAnimation() {
        checkmarkImageView.alpha = 0
        titleLabel.alpha = 0
        dividerView.alpha = 0
        bodyLabel.alpha = 0
        mainStackView.spacing = 24
        mainStackTopConstraint?.constant = mainStackTopConstraintConstant + 300
        view.layoutIfNeeded()
    }

    override func performIntroAnimation(with completion: @escaping ((Bool) -> Void)) {
        if viewModel.progressViewShouldBeHidden {
            delegate?.performProgressViewAnimation(isIntro: false, with: { (_) in
                self.performStageOutroAnimation(with: completion)
            })
        } else {
            performStageOutroAnimation(with: completion)
        }
    }

}

// MARK: - Private Functions
private extension OnboardingStageCompletedViewController {
    
    func performStageOutroAnimation(with completion: @escaping (Bool) -> Void) {
        let duration: TimeInterval = 1.25
        let delay: TimeInterval = 0.35
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: [.curveEaseOut],
                       animations: {
                        self.mainStackTopConstraint?.constant = self.mainStackTopConstraintConstant
                        self.mainStackView.spacing = 0
                        self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animateKeyframes(withTotalDuration: duration, delay: delay, keyframes: [ {
            self.checkmarkImageView.alpha = 1
        }, {
            self.titleLabel.alpha = 1
            self.dividerView.alpha = 1
        }, {
            self.bodyLabel.alpha = 1
        }
        ]) { (finished) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion(finished)
                self.viewModel.stage.completeSection()
                self.delegate?.editorViewController(viewController: self,
                                                    updateStage: self.viewModel.stage)
                self.goToNextStep()
            }
        }
    }

}
