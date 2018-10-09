//
//  FilterSelectionHeaderView.swift
//  CrossFit Games
//
//  Created by Malinka S on 11/21/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

final class FilterSelectionHeaderView: UITableViewHeaderFooterView {

    // MARK: - Public Properties
    
    /// Height constant of the header view
    static let viewHeight: CGFloat = 80

    // MARK: - Private Properties
    
    @IBOutlet private weak var filterButton: StyleableButton!
    @IBOutlet private weak var filterSelectionLabel: StyleableLabel!

    /// Delegate for the filter header view
    weak var delegate: FilterSelectionHeaderViewDelegate!

    /// Text to be displayed based on the filter selection
    var filterSelectionValue: String? {
        didSet {
            if let newValue = filterSelectionValue {
                filterSelectionLabel.text = newValue
            }
        }
    }

    private let localization = GeneralLocalization()

    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.backgroundColor = .white
    }

    // MARK: - Public Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        filterButton.setTitle(localization.filter, for: .normal)
    }

    /// Update the filter selection text frame size based on the scroll content offset value
    ///
    /// - Parameter value: scroll content offset value
    func changeFilterSelectionText(value: CGFloat) {
        if value > 0 {
            filterSelectionLabel.row = 2
        } else {
            filterSelectionLabel.row = 10
        }
    }

    @IBAction private func didSelectFilters() {
        delegate?.didSelectFilters(on: self)
    }
    
}
