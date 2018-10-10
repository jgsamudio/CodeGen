//
//  OnboardingStageView.swift
//  TheWing
//
//  Created by Luna An on 7/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class OnboardingStageView: BuildableView {
    
    // MARK: - Public Properties
    
    /// What state is this view currently presenting?
    var state: OnboardingStageState?
    
    lazy var imageView = UIImageView(image: #imageLiteral(resourceName: "gray_circle_empty"))
    
    // MARK: - Private Properties

    private lazy var titleLabel = UILabel()
    
    private var titleLabelLayoutConstraint: NSLayoutConstraint?
    
    // MARK: - Initialization
    
    init(title: String, theme: Theme) {
        super.init(theme: theme)
        setupTitle(title: title)
        setupImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Updates the view.
    ///
    /// - Parameter state: Onboarding stage state.
    func updateView(state: OnboardingStageState) {
        self.state = state
        switch state {
        case .notStarted:
            imageView.image = #imageLiteral(resourceName: "gray_circle_empty")
            setupTitleActiveState(false)
        case .inProgress:
            imageView.image = #imageLiteral(resourceName: "blue_circle_incomplete")
            setupTitleActiveState(true)
        case .completed:
            imageView.image = #imageLiteral(resourceName: "blue_circle_completed")
            setupTitleActiveState(true)
        case .sectionCompleted:
            imageView.image = #imageLiteral(resourceName: "pink_circle_completed")
            setupTitleActiveState(false)
        }
    }
    
    func animateTitleLabel(isHidden: Bool) {
        titleLabelLayoutConstraint?.constant = isHidden ? -8 : 0
        titleLabel.alpha = isHidden ? 0 : 1
        layoutIfNeeded()
    }
    
}

// MARK: - Private Functions
private extension OnboardingStageView {
    
    func setupTitle(title: String) {
        addSubview(titleLabel)
        let textStyle = theme.textStyleTheme.captionSmall.withCharacterSpacing(1).withColor(theme.colorTheme.tertiary)
        titleLabel.setMarkdownText("**\(title.uppercased())**", using: textStyle)
        titleLabelLayoutConstraint = titleLabel.autoPinEdge(toSuperviewEdge: .bottom)
        titleLabel.autoPinEdge(toSuperviewEdge: .left)
        titleLabel.autoPinEdge(toSuperviewEdge: .right)
    }
    
    func setupImageView() {
        addSubview(imageView)
        imageView.autoPinEdge(.top, to: .top, of: self)
        imageView.autoAlignAxis(.vertical, toSameAxisOf: titleLabel)
    }
    
    func setupTitleActiveState(_ isActive: Bool) {
        titleLabel.textColor = isActive ? theme.colorTheme.primary : theme.colorTheme.tertiary
    }

}
