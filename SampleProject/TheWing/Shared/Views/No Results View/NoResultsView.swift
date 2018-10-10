//
//  NoResultsView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 8/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation
import UIKit

final class NoResultsView: BuildableView {

    // MARK: - Private Properties
    
    private weak var delegate: NoResultDelegate?

    private var noResultsImageView = UIImageView(image: #imageLiteral(resourceName: "no_dice_icon"))

    private lazy var titleLabel = UILabel(text: "NO_DICE".localized(comment: "No Dice!"),
                                          using: textStyleTheme.headline4)

    private lazy var descriptionLabel =
        UILabel(text: "NO_MATCH_DESCRIPTION".localized(comment: "We couldn't find your match"),
                using: textStyleTheme.bodyNormal,
                numberOfLines: 0,
                alignment: .center)

    private lazy var refineFilterButton: StylizedButton = {
    
    // MARK: - Public Properties
    
        let button = StylizedButton(buttonStyle: theme.buttonStyleTheme.secondaryDarkSmallButtonStyle)
        button.setTitle("ROLL_AGAIN".localized(comment: "Roll Again"))
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
        button.addTarget(self, action: #selector(refineFiltersButtonSelected), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomSpaceView = UIView()

    private var imageViewTopConstraint: NSLayoutConstraint?

    // MARK: - Initialization

    init(theme: Theme, delegate: NoResultDelegate?) {
        self.delegate = delegate
        super.init(theme: theme)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /// Transitions the view with the given parameters.
    ///
    /// - Parameters:
    ///   - show: Determines if the view should be shown or hidden.
    ///   - animate: Determines if the view animates.
    func transition(show: Bool, animate: Bool) {
        guard animate else {
            alpha = show ? 1 : 0
            return
        }
        UIView.animate(withDuration: AnimationConstants.fastAnimationDuration) {
            self.alpha = show ? 1 : 0
        }
    }
    
    /// Updates the image view top constraint.
    ///
    /// - Parameter constant: Constant.
    func updateTopConstant(constant: CGFloat) {
        imageViewTopConstraint?.constant = constant
    }

}

// MARK: - Private Functions
private extension NoResultsView {

    func setupView() {
        backgroundColor = colorTheme.invertPrimary
        setupImageView()
        setupTitleLabel()
        setupDescriptionLabel()
        setupRefineFilterButton()
        setupBottomSpacing()
    }

    func setupImageView() {
        addSubview(noResultsImageView)
        noResultsImageView.autoSetDimensions(to: CGSize(width: 149, height: 127))
        noResultsImageView.autoAlignAxis(.vertical, toSameAxisOf: self)
        imageViewTopConstraint = noResultsImageView.autoPinEdge(.top, to: .top, of: self)
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.autoAlignAxis(.vertical, toSameAxisOf: noResultsImageView)
        titleLabel.autoPinEdge(.top, to: .bottom, of: noResultsImageView, withOffset: 20)
    }
    
    func setupDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.autoAlignAxis(.vertical, toSameAxisOf: titleLabel)
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 5)
    }

    func setupRefineFilterButton() {
        addSubview(refineFilterButton)
        refineFilterButton.autoAlignAxis(.vertical, toSameAxisOf: descriptionLabel)
        refineFilterButton.autoPinEdge(.top, to: .bottom, of: descriptionLabel, withOffset: 24)
        refineFilterButton.autoSetDimension(.width, toSize: 138)
        refineFilterButton.set(height: 34)
    }
    
    func setupBottomSpacing() {
        addSubview(bottomSpaceView)
        bottomSpaceView.autoAlignAxis(.vertical, toSameAxisOf: refineFilterButton)
        bottomSpaceView.autoPinEdge(.top, to: .bottom, of: refineFilterButton)
        bottomSpaceView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -100)
    }

    @objc func refineFiltersButtonSelected() {
        delegate?.refineFiltersSelected()
    }

}
