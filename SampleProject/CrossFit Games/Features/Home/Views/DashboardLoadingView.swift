//
//  DashboardLoadingView.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 12/15/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Loading view for dashboard screen.
final class DashboardLoadingView: FullscreenLoadingView {

    // MARK: - Private Properties
    
    @IBOutlet private weak var avatarPlaceholder: UIView!
    @IBOutlet private weak var shimmerView: UIView!

    // MARK: - Public Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()

        avatarPlaceholder.layer.cornerRadius = 24
        avatarPlaceholder.clipsToBounds = true
        shimmerView.startShimmer()
    }

}
