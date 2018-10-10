//
//  DashboardCardCell.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/8/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Cell displayed for a dashboard card.
final class DashboardCardCell: UICollectionViewCell {

    // MARK: - Private Properties
    
    @IBOutlet private weak var yearLabel: UILabel!

    @IBOutlet private weak var divisionNameLabel: UILabel!

    @IBOutlet private weak var rankNameLabel: UILabel!

    @IBOutlet private weak var userRankLabel: StyleableLabel!

    @IBOutlet private weak var maxRankLabel: UILabel!

    @IBOutlet private weak var transitionContentView: UIView!

    @IBOutlet private weak var backgroundImageView: UIImageView!

    @IBOutlet private weak var dashboardSlash: UIImageView!

    // MARK: - Public Properties
    
    /// Year displayed in `self`.
    var year: String? {
        didSet {
            yearLabel.text = year
        }
    }

    /// Division name displayed in `self`.
    var divisionName: String? {
        didSet {
            divisionNameLabel.text = divisionName
        }
    }

    /// Rank name displayed in `self`.
    var rankName: String? {
        didSet {
            rankNameLabel.text = rankName
        }
    }

    /// User rank displayed in `self`.
    var userRank: String? {
        didSet {
            userRankLabel.text = userRank

            if let nDigits = userRank?.count {
                userRankLabel.row = nDigits > 4 ? 12 : 13
            }
        }
    }

    /// Max rank displayed in `self`.
    var maxRank: String? {
        didSet {
            guard let maxRank = maxRank else {
                maxRankLabel.isHidden = true
                dashboardSlash.isHidden = true
                return
            }
            maxRankLabel.isHidden = false
            dashboardSlash.isHidden = false
            maxRankLabel.text = maxRank
        }
    }

    /// Factor of how much content should be offset for parallax effect due to scrolling.
    var translationFactor: CGFloat = 0 {
        didSet {
            transitionContentView.transform = CGAffineTransform(translationX: parallaxOffset * translationFactor, y: 0)
            transitionContentView.alpha = 1 - abs(translationFactor)
        }
    }

    /// Background image for the cell.
    var backgroundImage: UIImage = UIImage() {
        didSet {
            backgroundImageView.image = backgroundImage
        }
    }

    private let parallaxOffset: CGFloat = -70

    // MARK: - Public Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()

        yearLabel.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        yearLabel.transform = CGAffineTransform(rotationAngle: -.pi / 2)
    }

}
