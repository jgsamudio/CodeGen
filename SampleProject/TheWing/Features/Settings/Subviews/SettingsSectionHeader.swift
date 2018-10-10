//
//  SettingsSectionHeader.swift
//  TheWing
//
//  Created by Luna An on 8/2/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class SettingsSectionHeader: UITableViewHeaderFooterView {
    
    // MARK: - Private Properties
    
    private lazy var titleLabel = UILabel()
    
    // MARK: - Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: self, withOffset: 8)
        titleLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets up the header view.
    ///
    /// - Parameters:
    ///   - theme: Theme.
    ///   - title: Title to display.
    func setup(theme: Theme, title: String?) {
        contentView.backgroundColor = theme.colorTheme.invertPrimary
        titleLabel.setText(title ?? "", using: theme.textStyleTheme.headline4)
    }
    
}
