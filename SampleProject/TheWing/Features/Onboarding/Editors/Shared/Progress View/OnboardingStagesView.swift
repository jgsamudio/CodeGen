//
//  OnboardingStagesView.swift
//  TheWing
//
//  Created by Luna An on 7/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OnboardingStagesView: BuildableView {

    // MARK: - Public Properties
    
    weak var delegate: OnboardingStagesViewDelegate?
    
    // MARK: - Private Properties
    
    private lazy var basicsAboutYouStagesConnector = UIView.dividerView(height: 1, color: theme.colorTheme.tertiary)

    private lazy var aboutYouAsksAndOffersStagesConnector = UIView.dividerView(height: 1, color: theme.colorTheme.tertiary)
        
    private lazy var basicsView: OnboardingStageView = {
        let view = OnboardingStageView(title: OnboardingLocalization.basicsTitle, theme: theme)
        view.addGestureRecognizer(basicsViewGesture)
        return view
    }()
    
    private lazy var basicsViewGesture = UITapGestureRecognizer(target: self, action: #selector(stageViewSelected(sender:)))
    
    private lazy var aboutYouView: OnboardingStageView = {
        let view = OnboardingStageView(title: OnboardingLocalization.aboutYouTitle, theme: theme)
        view.addGestureRecognizer(aboutYouGesture)
        return view
    }()
    
    private lazy var aboutYouGesture = UITapGestureRecognizer(target: self, action: #selector(stageViewSelected(sender:)))
    
    private lazy var asksAndOffersView: OnboardingStageView = {
        let view = OnboardingStageView(title: OnboardingLocalization.asksAndOffersTitle, theme: theme)
        view.addGestureRecognizer(asksOffersGesture)
        return view
    }()
    
    private lazy var asksOffersGesture = UITapGestureRecognizer(target: self, action: #selector(stageViewSelected(sender:)))
    
    private lazy var gestures: [UITapGestureRecognizer] = [basicsViewGesture, aboutYouGesture, asksOffersGesture]
    
    private var basicsTopConstraint: NSLayoutConstraint?
    
    private var aboutYouTopConstraint: NSLayoutConstraint?
    
    private var asksAndOffersTopConstraint: NSLayoutConstraint?
    
    private var basicsAboutYouConnectorConstraint: NSLayoutConstraint?
    
    private var aboutYouAsksAndOffersConnectorConstraint: NSLayoutConstraint?
    
    private var animationShivConstant: CGFloat = -100
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions
    
    /// Updates the corresponding stage view.
    ///
    /// - Parameter stage: Onboarding stage. ( e.g. basics, asksAndOffers, aboutYou )
    func updateStageView(stage: OnboardingProgressStage) {
        switch stage {
        case .basics(let state):
            basicsView.updateView(state: state)
        case .aboutYou(let state):
            aboutYouView.updateView(state: state)
        case .asksAndOffers(let state):
            asksAndOffersView.updateView(state: state)
        }
        updateProgressConnector(with: stage)
    }
    
    func prepareForAnimation(isIntro: Bool) {
        basicsTopConstraint?.constant = isIntro ? animationShivConstant : 0
        aboutYouTopConstraint?.constant = isIntro ? animationShivConstant : 0
        asksAndOffersTopConstraint?.constant = isIntro ? animationShivConstant : 0
        basicsAboutYouStagesConnector.alpha = isIntro ? 0 : 1
        aboutYouAsksAndOffersStagesConnector.alpha = isIntro ? 0 : 1
        basicsView.animateTitleLabel(isHidden: isIntro)
        aboutYouView.animateTitleLabel(isHidden: isIntro)
        asksAndOffersView.animateTitleLabel(isHidden: isIntro)
        layoutIfNeeded()
    }
    
    func performAnimation(isIntro: Bool, with completion: @escaping (Bool) -> Void) {
        gestures.forEach({ $0.isEnabled = false })
        var keyframes = [ {
            self.basicsTopConstraint?.constant = isIntro ? 0 : self.animationShivConstant
            self.layoutIfNeeded()
        }, {
            self.aboutYouTopConstraint?.constant = isIntro ? 0 : self.animationShivConstant
            self.layoutIfNeeded()
        }, {
            self.asksAndOffersTopConstraint?.constant = isIntro ? 0 : self.animationShivConstant
            self.layoutIfNeeded()
        }, {
            self.addConstraint(self.basicsAboutYouConnectorConstraint!)
            self.basicsAboutYouStagesConnector.alpha = isIntro ? 1 : 0
            self.layoutIfNeeded()
        }, {
            self.addConstraint(self.aboutYouAsksAndOffersConnectorConstraint!)
            self.aboutYouAsksAndOffersStagesConnector.alpha = isIntro ? 1 : 0
            self.layoutIfNeeded()
        }, {
            self.basicsView.animateTitleLabel(isHidden: !isIntro)
        }, {
            self.aboutYouView.animateTitleLabel(isHidden: !isIntro)
        }, {
            self.asksAndOffersView.animateTitleLabel(isHidden: !isIntro)
        }]
        
        if !isIntro {
            keyframes.reverse()
        }
        
        let duration = 0.25
        UIView.animateKeyframes(eachWithDuration: duration, keyframes: keyframes) { (finished) in
            if isIntro {
                // if it's not the intro, this about to be hidden forever, so don't re-enable theme.
                // If they're presented again they'll get intro so it should be fine.
                self.gestures.forEach({ $0.isEnabled = true })
            }
            completion(finished)
        }
    }

}

// MARK: - Private Functions
private extension OnboardingStagesView {
    
    func setupView() {
        autoSetDimension(.height, toSize: 51)
        addSubview(basicsAboutYouStagesConnector)
        addSubview(aboutYouAsksAndOffersStagesConnector)
        addSubview(basicsView)
        addSubview(aboutYouView)
        addSubview(asksAndOffersView)
        setupStepsView()
        setupStepsConnector()
    }
    
    func updateProgressConnector(with stage: OnboardingProgressStage) {
        switch stage {
        case .aboutYou:
            basicsAboutYouStagesConnector.backgroundColor = theme.colorTheme.primary
        case .asksAndOffers:
            aboutYouAsksAndOffersStagesConnector.backgroundColor = theme.colorTheme.primary
        default:
            return
        }
    }
    
    private func setupStepsConnector() {
        basicsAboutYouStagesConnector.autoPinEdge(.top, to: .top, of: self, withOffset: 11)
        basicsAboutYouStagesConnector.autoPinEdge(.leading, to: .trailing, of: basicsView.imageView)
        basicsAboutYouConnectorConstraint = basicsAboutYouStagesConnector.autoPinEdge(.trailing,
                                                                                      to: .leading,
                                                                                      of: aboutYouView.imageView)
        removeConstraint(basicsAboutYouConnectorConstraint!)
        
        aboutYouAsksAndOffersStagesConnector.autoPinEdge(.top, to: .top, of: self, withOffset: 11)
        aboutYouAsksAndOffersStagesConnector.autoPinEdge(.leading, to: .trailing, of: aboutYouView.imageView)
        let imageView = asksAndOffersView.imageView
        aboutYouAsksAndOffersConnectorConstraint = aboutYouAsksAndOffersStagesConnector.autoPinEdge(.trailing,
                                                                                                    to: .leading,
                                                                                                    of: imageView)
        removeConstraint(aboutYouAsksAndOffersConnectorConstraint!)
    }
    
    private func setupStepsView() {
        basicsTopConstraint = basicsView.autoPinEdge(toSuperviewEdge: .top)
        basicsView.autoPinEdge(toSuperviewEdge: .leading)
        basicsView.autoPinEdge(toSuperviewEdge: .bottom)
        
        asksAndOffersView.autoPinEdge(toSuperviewEdge: .trailing)
        asksAndOffersView.autoPinEdge(toSuperviewEdge: .bottom)
        asksAndOffersTopConstraint = asksAndOffersView.autoPinEdge(toSuperviewEdge: .top)
        
        aboutYouTopConstraint = aboutYouView.autoPinEdge(.top, to: .top, of: self)
        aboutYouView.autoPinEdge(.bottom, to: .bottom, of: self)
        aboutYouView.autoAlignAxis(.vertical, toSameAxisOf: self, withOffset: -12)
    }
    
    @objc func stageViewSelected(sender: UITapGestureRecognizer) {
        if let view = sender.view as? OnboardingStageView {
            if let state = view.state {
                guard state != .notStarted else {
                    return
                }
                
                switch view {
                case basicsView:
                    delegate?.onboardingStagesView(self, didSelectStage: .basics(state))
                case aboutYouView:
                    delegate?.onboardingStagesView(self, didSelectStage: .aboutYou(state))
                case asksAndOffersView:
                    delegate?.onboardingStagesView(self, didSelectStage: .asksAndOffers(state))
                default:
                    assert(false)
                }
            }
        } else {
            assert(false)
        }
    }
    
}

