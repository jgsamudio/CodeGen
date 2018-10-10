//
//  EditOccupationItem.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EditOccupationItem: UIView {

    // MARK: - Public Properties

    weak var delegate: EditOccupationItemDelegate?

    // MARK: - Private Properties

    private var headlineLabel = UILabel()
    private var occupationLabel = UILabel()
    private var editButton = UIButton()
    private var verticalSeparatorView = UIView()
    private var bottomSeparatorView = UIView()

    private let theme: Theme

    private let occupation: Occupation

    // MARK: - Initialization

    init(theme: Theme, occupation: Occupation, isRequired: Bool) {
        self.theme = theme
        self.occupation = occupation
        super.init(frame: CGRect.zero)
        setupView()
        setupDesign(occupation: occupation, isRequired: isRequired)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private Functions
private extension EditOccupationItem {

    func setupView() {
        addSubview(headlineLabel)
        addSubview(editButton)
        addSubview(occupationLabel)
        addSubview(bottomSeparatorView)
        addSubview(verticalSeparatorView)

        setupHeadline()
        setupOccupationLabel()
        setupEditButton()
        setupBottomSeparator()
        setupVerticalSeparatorView()
    }

    func setupOccupationLabel() {
        occupationLabel.numberOfLines = 0
        occupationLabel.autoPinEdge(.top, to: .bottom, of: headlineLabel, withOffset: 7)
        occupationLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: ViewConstants.defaultGutter)
        occupationLabel.autoPinEdge(.trailing, to: .leading, of: verticalSeparatorView, withOffset: -8)
        occupationLabel.autoPinEdge(.bottom, to: .top, of: bottomSeparatorView, withOffset: -10)
    }

    func setupEditButton() {
        editButton.autoSetDimensions(to: ViewConstants.defaultButtonSize)
        editButton.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -19)
        editButton.autoAlignAxis(.horizontal, toSameAxisOf: verticalSeparatorView)
        editButton.addTarget(self, action: #selector(editOccupationSelected), for: .touchUpInside)
        editButton.setImage(#imageLiteral(resourceName: "edit_button"), for: .normal)
    }

    func setupHeadline() {
        let insets = UIEdgeInsets(top: 3, left: ViewConstants.defaultGutter, bottom: 0, right: 0)
        headlineLabel.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .bottom)
        headlineLabel.autoSetDimension(.height, toSize: 14)
    }

    func setupBottomSeparator() {
        bottomSeparatorView.backgroundColor = theme.colorTheme.tertiaryFaded
        bottomSeparatorView.autoSetDimension(.height, toSize: ViewConstants.lineSeparatorThickness)
        let insets = UIEdgeInsets(top: 0,
                                  left: ViewConstants.defaultGutter,
                                  bottom: 14,
                                  right: ViewConstants.defaultGutter)
        bottomSeparatorView.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .top)
    }

    func setupVerticalSeparatorView() {
        verticalSeparatorView.backgroundColor = theme.colorTheme.tertiaryFaded
        verticalSeparatorView.autoSetDimensions(to: CGSize(width: 1.0, height: 32))
        verticalSeparatorView.autoPinEdge(.trailing, to: .leading, of: editButton, withOffset: -3.5)
        verticalSeparatorView.autoAlignAxis(.horizontal, toSameAxisOf: self, withOffset: -14)
    }

    func setupDesign(occupation: Occupation, isRequired: Bool) {
        let localizable = isRequired ? "CURRENT_OCCUPATION_REQUIRED" : "CURRENT_OCCUPATION"
        headlineLabel.setText(localizable.localized(comment: "Current Occupation"),
                              using: theme.textStyleTheme.subheadlineNormal.withLineSpacing(0))
        let textStyle = theme.textStyleTheme.bodyNormal.withColor(theme.colorTheme.emphasisQuintary)
        occupationLabel.setText(occupation.formattedText(), using: textStyle)
    }

    @objc func editOccupationSelected() {
        delegate?.editOccupationSelected(occupation: occupation)
    }

}
