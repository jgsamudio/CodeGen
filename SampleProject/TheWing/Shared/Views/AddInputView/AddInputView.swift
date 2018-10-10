//
//  AddInputView.swift
//  TheWing
//
//  Created by Luna An on 4/7/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class AddInputView: UIView {
    
    // MARK: - Private Properties
    
    private lazy var addImageView: UIImageView = {
    
    // MARK: - Public Properties
    
        let imageView = UIImageView(image: #imageLiteral(resourceName: "plus_button"))
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var inputLabel: UILabel = {
        let label = UILabel(numberOfLines: 0)
        label.sizeToFit()
        addSubview(label)
        let insets = UIEdgeInsets(top: ViewConstants.searchCellGutter,
                                  left: 42,
                                  bottom: ViewConstants.searchCellGutter,
                                  right: ViewConstants.defaultGutter)
        label.autoPinEdgesToSuperviewEdges(with: insets)
        return label
    }()
    
    private lazy var imageViewTopConstraint: NSLayoutConstraint = {
        return addImageView.autoPinEdge(.top, to: .top, of: self, withOffset: 16)
    }()
    
    private lazy var imageViewLeadingConstraint: NSLayoutConstraint = {
        return addImageView.autoPinEdge(.leading, to: .leading, of: self, withOffset: 14)
    }()
    
    // MARK: - Public Functions
    
    /// Sets up a result table view cell with a result text.
    ///
    /// - Parameters:
    ///   - theme: The theme.
    ///   - input: The input string to display.
    func setup(theme: Theme, input: String?) {
        setupInputView(theme: theme, input: input)
    }
    
}

// MARK: - Private Functions
private extension AddInputView {
    
    func setupInputView(theme: Theme, input: String?) {
        imageViewTopConstraint.constant = 16
        imageViewLeadingConstraint.constant = 14
        
        if let input = input {
            let textStyle = theme.textStyleTheme.subheadlineLarge.withColor(theme.colorTheme.emphasisPrimary)
            inputLabel.setText(configureFormattedUserInput(input: input), using: textStyle)
        }
    }
    
    func configureFormattedUserInput(input: String) -> String {
        let addText = "ADD_TEXT".localized(comment: "Add text")
        return String(format: addText, input)
    }
    
}
