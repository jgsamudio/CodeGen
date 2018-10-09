//
//  FilterNestedSelectionCell.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/28/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Cell for going into a nested filter selection.
final class FilterNestedSelectionCell: UITableViewCell {

    // MARK: - Private Properties
    
    @IBOutlet private weak var nameLabel: UILabel!

    @IBOutlet private weak var selectedOptionLabel: UILabel!

    @IBOutlet private weak var chevronImageView: UIImageView!

    // MARK: - Public Properties
    
    /// Theme configuration for `self`.
    var config: FilterThemeConfiguration? {
        didSet {
            setup()
        }
    }

    /// Name of the selection option in `self`.
    var name: String? {
        didSet {
            setup()
        }
    }

    /// Name of the nested, selected option.
    var selectedOptionName: String? {
        didSet {
            setup()
        }
    }

    private func setup() {
        nameLabel.attributedText = NSAttributedString(string: name ?? "", attributes: config?.optionTitleAttributes)
        let alignment = selectedOptionLabel.textAlignment
        selectedOptionLabel.attributedText = NSAttributedString(string: selectedOptionName ?? "", attributes: config?.optionTitleAttributes)
        selectedOptionLabel.textAlignment = alignment
        chevronImageView.tintColor = config?.selectedOptionCheckmarkTintColor
        contentView.backgroundColor = config?.backgroundColor
    }

}
