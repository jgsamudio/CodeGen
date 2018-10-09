//
//  DashboardStatsLoadingView.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 12/18/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

final class DashboardStatsLoadingView: FullscreenLoadingView {

    @IBOutlet weak var shimmerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        shimmerView.startShimmer()
    }
}
