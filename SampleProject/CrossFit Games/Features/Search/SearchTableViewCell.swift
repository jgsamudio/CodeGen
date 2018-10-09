//
//  SearchTableViewCell.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/22/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Cell to display Search information
final class SearchTableViewCell: UITableViewCell {

    // MARK: - Public Properties
    
    static let heightEstimate = CGFloat(72)

    // MARK: - Private Properties
    
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var bottomLabel: UILabel!

    // MARK: - Public Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /// Setup Cell
    ///
    /// - Parameters:
    ///   - top: String to set for top label
    ///   - bottom: String to set for bottom label
    func setup(top: String, bottom: String) {
        topLabel.attributedText = NSAttributedString(string: top,
                                                     attributes: StyleGuide.shared.style(row: .r2, column: .c4, weight: .w2))
        bottomLabel.attributedText = NSAttributedString(string: bottom,
                                                        attributes: StyleGuide.shared.style(row: .r2, column: .c5, weight: .w2))
    }
    
}
