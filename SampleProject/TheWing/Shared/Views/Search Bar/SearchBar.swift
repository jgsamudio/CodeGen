//
//  SearchBar.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class SearchBar: BuildableView {

    // MARK: - Private Properties

    private var searchTextField = UITextField()
    private var searchImage = UIImageView(image: #imageLiteral(resourceName: "search"))

    // MARK: - Initialization

    override init(theme: Theme) {
        super.init(theme: theme)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions

    /// Sets the text of the view with styling for a placeholder string.
    ///
    /// - Parameter text: Placeholder text string.
    func setPlaceholder(text: String) {
        searchTextField.setText(text, using: theme.textStyleTheme.bodyNormal)
    }

}

// MARK: - Private Functions
private extension SearchBar {

    func setupView() {
        backgroundColor = theme.colorTheme.invertTertiary
        layer.borderWidth = ViewConstants.lineSeparatorThickness
        layer.borderColor = theme.colorTheme.emphasisQuaternary.cgColor
        layer.cornerRadius = 9
        setupImage()
        setupSearchTextField()
    }

    func setupImage() {
        addSubview(searchImage)
        searchImage.autoSetDimensions(to: CGSize(width: 14, height: 14))
        searchImage.autoPinEdge(.leading, to: .leading, of: self, withOffset: 14)
        searchImage.autoAlignAxis(toSuperviewAxis: .horizontal)
    }
    
    func setupSearchTextField() {
        addSubview(searchTextField)
        searchTextField.isUserInteractionEnabled = false
        searchTextField.autoPinEdge(.bottom, to: .bottom, of: searchImage, withOffset: -1)
        searchTextField.autoPinEdge(.leading, to: .trailing, of: searchImage, withOffset: 6)
    }

}
