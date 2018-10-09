//
//  LeaderboardResultLoaderTableViewCell.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 12/12/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Shows loader for leaderboard result
final class LeaderboardResultLoaderTableViewCell: UITableViewCell {

    @IBOutlet private weak var circleView: UIView!
    @IBOutlet private weak var topSeparatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        circleView.layer.masksToBounds = true
        circleView.layer.cornerRadius = circleView.frame.width / 2
    }

    /// Hides Top Separator View
    func hideTopSeparator() {
        topSeparatorView.isHidden = true
    }

}
