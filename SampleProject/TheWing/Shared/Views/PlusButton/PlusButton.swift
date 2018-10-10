//
//  PlusButton.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class PlusButton: UIButton {

    // MARK: - Private Properties

    private let theme: Theme

    // MARK: - Initialization

    init(theme: Theme) {
        self.theme = theme
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /// Sets the title of the plus button.
    ///
    /// - Parameter text: Text to set the title to.
    func set(text: String) {
    
    // MARK: - Public Properties
    
        let textStyle = theme.textStyleTheme.subheadlineLarge.withColor(theme.colorTheme.emphasisPrimary)
        setTitleText(text, using: textStyle.withMinLineHeight(0))
    }

}

// MARK: - Private Functions
private extension PlusButton {

    func setupButton() {
        contentHorizontalAlignment = .left
        setImage(#imageLiteral(resourceName: "plus_button"), for: .normal)
        let imageLeadingInset: CGFloat = 48
        let titleLeadingInset: CGFloat = 11
        titleEdgeInsets = UIEdgeInsets(top: 0, left: imageLeadingInset + titleLeadingInset, bottom: 0, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: imageLeadingInset, bottom: 0, right: 0)
        autoSetDimension(.width, toSize: 240)
        autoSetDimension(.height, toSize: ViewConstants.defaultButtonSize.height)
    }

}
