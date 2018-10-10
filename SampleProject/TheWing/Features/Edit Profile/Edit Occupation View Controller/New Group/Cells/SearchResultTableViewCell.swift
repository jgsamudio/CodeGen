//
//  SearchResultTableViewCell.swift
//  TheWing
//
//  Created by Luna An on 4/5/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class SearchResultTableViewCell: UITableViewCell {
    
    // MARK: - Private Properties

    private lazy var resultLabel: UILabel = {
    
    // MARK: - Public Properties
    
        let label = UILabel(numberOfLines: 0)
        label.sizeToFit()
        return label
    }()
    
    // MARK: - Public Functions
    
    /// Sets up a result table view cell with a result string.
    ///
    /// - Parameters:
    ///   - theme: The theme.
    ///   - result: The search result to display.
    func setup(theme: Theme, result: String) {
        setupTableViewViewCell(theme: theme, result: result)
    }
    
}

// MARK: - Private Functions
private extension SearchResultTableViewCell {
    
    func setupTableViewViewCell(theme: Theme, result: String) {
        addSubview(resultLabel)
        let insets = UIEdgeInsets(top: ViewConstants.searchCellGutter,
                                  left: ViewConstants.defaultGutter,
                                  bottom: ViewConstants.searchCellGutter,
                                  right: ViewConstants.defaultGutter)
        resultLabel.autoPinEdgesToSuperviewEdges(with: insets)
        resultLabel.autoAlignAxis(.horizontal, toSameAxisOf: self)
        resultLabel.setText(result, using: theme.textStyleTheme.bodyNormal)
    }
    
}
