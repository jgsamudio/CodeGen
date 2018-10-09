//
//  LeaderboardFilterItemCell.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/9/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Cell for displaying filter question & answer option
final class LeaderboardFilterItemCell: UICollectionViewCell {

    @IBOutlet private weak var filterNameLabel: UILabel!

    var filterName: String? {
        didSet {
            filterNameLabel.text = filterName
        }
    }

}
