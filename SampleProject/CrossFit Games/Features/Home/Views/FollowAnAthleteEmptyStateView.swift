//
//  FollowAnAthleteEmptyStateView.swift
//  CrossFit Games
//
//  Created by Malinka S on 2/5/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// UI nib file for the empty state of Follow An Athlete
final class FollowAnAthleteEmptyStateView: UIView {

    // MARK: - Private Properties
    
    @IBOutlet private weak var placeholderView: UIView!

    // MARK: - Public Functions
    
    /// Initializes an instance of FollowAnAthleteEmptyStateView from the nib file
    ///
    /// - Returns: An instance of FollowAnAthleteEmptyStateView
    func initFromNib() -> FollowAnAthleteEmptyStateView? {
        guard let view = UINib(nibName: String(describing: FollowAnAthleteEmptyStateView.self), bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as? FollowAnAthleteEmptyStateView else {
                return nil
        }
        view.placeholderView.layer.cornerRadius = 4
        applyShadow(view: view.placeholderView)
        return view
    }

    private func applyShadow(view: UIView) {
    
    // MARK: - Public Properties
    
        let layer = view.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 5
        layer.masksToBounds =  false
    }
}
