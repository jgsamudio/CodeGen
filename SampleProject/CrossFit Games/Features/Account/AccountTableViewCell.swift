//
//  AccountTableViewCell.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 11/28/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Displays Account information
final class AccountTableViewCell: UITableViewCell {

    // MARK: - Public Properties
    
    /// Height Estimate for cell
    static let heightEstimate = CGFloat(56)

    /// Label Contents to display account information
    var labelContent: String? {
        didSet {
            label.text = labelContent
        }
    }

    // MARK: - Private Properties
    
    @IBOutlet private weak var label: StyleableLabel!

}
