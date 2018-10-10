//
//  ModalDescriptionView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 5/10/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class ModalDescriptionView: BuildableView {

    // MARK: - Private Properties

    private lazy var descriptionLabel = UILabel(numberOfLines: 0)

    // MARK: - Constants

    fileprivate static var gutter: CGFloat = 38

    // MARK: - Initialization

    override init(theme: Theme) {
        super.init(theme: theme)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /// Sets the description label.
    ///
    /// - Parameter description: description string.
    func set(description: String) {
    
    // MARK: - Public Properties
    
        let textstyle = theme.textStyleTheme.bodyLarge.withMinLineHeight(27).withCharacterSpacing(-0.34)
        descriptionLabel.setText(description, using: textstyle)
    }

}

// MARK: - Private Functions
private extension ModalDescriptionView {

    func setupView() {
        backgroundColor = theme.colorTheme.invertSecondary
        setupFeeDescriptionLabel()
    }

    func setupFeeDescriptionLabel() {
        addSubview(descriptionLabel)
        let insets = UIEdgeInsets(top: 34, left: ModalDescriptionView.gutter, bottom: 37, right: ModalDescriptionView.gutter)
        descriptionLabel.autoPinEdgesToSuperviewEdges(with: insets)
    }

}
