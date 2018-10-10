//
//  DashboardFollowAnAthleteLoadingView.swift
//  CrossFit Games
//
//  Created by Malinka S on 2/22/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Loading state view till the network request is completed
final class DashboardFollowAnAthleteLoadingView: UIView {

    // MARK: - Public Functions
    
    /// Initializes an instance of DashboardFollowAnAthleteLoadingView from the nib file
    ///
    /// - Returns: An instance of DashboardFollowAnAthleteLoadingView
    func initFromNib() -> DashboardFollowAnAthleteLoadingView? {
        guard let view = UINib(nibName: String(describing: DashboardFollowAnAthleteLoadingView.self), bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as? DashboardFollowAnAthleteLoadingView else {
                return nil
        }
        view.startActivityIndicator()
        return view
    }

}
