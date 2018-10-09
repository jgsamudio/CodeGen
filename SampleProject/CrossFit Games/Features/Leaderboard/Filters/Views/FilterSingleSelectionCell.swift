//
//  FilterSingleSelectionCell.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/28/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Cell for selecting a single filter option.
final class FilterSingleSelectionCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!

    @IBOutlet private weak var checkMarkImageView: UIImageView!

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

    override var isSelected: Bool {
        didSet {
            setup()
        }
    }

    private func setup() {
        checkMarkImageView.isHidden = !isSelected
        nameLabel.attributedText = NSAttributedString(string: name ?? "", attributes: config?.optionTitleAttributes)
        checkMarkImageView.image = #imageLiteral(resourceName: "checkmark").withRenderingMode(.alwaysTemplate)
        checkMarkImageView.tintColor = config?.selectedOptionCheckmarkTintColor
        contentView.backgroundColor = isSelected ? config?.selectedBackgroundColor : config?.backgroundColor
    }

}
