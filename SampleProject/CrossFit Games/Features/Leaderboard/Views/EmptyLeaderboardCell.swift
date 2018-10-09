//
//  EmptyLeaderboardCell.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/24/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EmptyLeaderboardCell: UITableViewCell {

    @IBOutlet weak var noResultsLabel: StyleableLabel!

    func setNoResultsLabelText(text: String) {
        noResultsLabel.text = text
    }
}
