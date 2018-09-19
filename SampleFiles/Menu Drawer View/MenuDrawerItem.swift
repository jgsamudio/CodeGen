//
//  MenuDrawerItem.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// <Description of the class>
///
/// **Subspec: Folder/Filename**
///
/// ```
/// Code Snippet
/// ```
///
/// <Real world example of how someone would use this class with code snippet>
/// ===== Generator Name: declarationHeader =====
final class MenuDrawerItem: UIView {

    // MARK: - Public Properties

    weak var delegate: MenuDrawerItemDelegate?

    // MARK: - Private Properties

    private let textLabel = UILabel()
    
    private let type: MenuItemType

    // MARK: - Initialization

// MARK: - Initialization
/// ===== Generator Name: initializationMark =====
    init(theme: Theme, type: MenuItemType, delegate: MenuDrawerItemDelegate?) {
        self.type = type
        self.delegate = delegate
        super.init(frame: .zero)
        configureView(theme: theme, text: type.title)
    }
// MARK: - Initialization
/// ===== Generator Name: initializationMark =====

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Functions
/// ===== Generator Name: privateExtensionMark =====
private extension MenuDrawerItem {

    func configureView(theme: Theme, text: String) {
        autoSetDimension(.height, toSize: 74)
        backgroundColor = theme.colorTheme.primary
        setupLabel(theme: theme, text: text)
        addDividerView(leadingOffset: ViewConstants.profileDrawerInset,
                       color: theme.colorTheme.invertTertiary.withAlphaComponent(0.1))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewSelected)))
    }

    func setupLabel(theme: Theme, text: String) {
        addSubview(textLabel)
        textLabel.autoAlignAxis(.horizontal, toSameAxisOf: self)
        textLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: ViewConstants.profileDrawerInset)

        let textStyle = theme.textStyleTheme.bodyLarge.withColor(theme.colorTheme.secondary)
        textLabel.setText(text, using: textStyle.withLineSpacing(0))
    }

    @objc func viewSelected() {
        delegate?.itemSelected(type: type)
    }
    
}
