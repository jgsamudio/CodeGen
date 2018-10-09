//
//  CollapsibleWorkoutHeader.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/25/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit
import AlamofireImage

final class WorkoutSectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet private weak var statusLabel: StyleableLabel!
    @IBOutlet private weak var liveIcon: UIImageView!

    private let localization = WorkoutsLocalization()

    /// Height constant of the header view
    static let viewHeight: CGFloat = 40

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// Specifies if the workout is live or not
    var isLive: Bool = false {
        didSet {
            if isLive {
                liveIcon.isHidden = false
                statusLabel.text = localization.live
            } else {
                liveIcon.isHidden = true
                statusLabel.text = localization.completed
            }
        }
    }

}
