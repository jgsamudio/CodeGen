//
//  DashboardFollowAnAthleteErrorView.swift
//  CrossFit Games
//
//  Created by Malinka S on 2/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Error state view for follow an athlete
/// Will be displayed when a network request occurs
final class DashboardFollowAnAthleteErrorView: UIView {

    // MARK: - Private Properties
    
    @IBOutlet private weak var refreshButton: StyleableButton!

    /// Tap action for the button.
    private var tapAction: (@escaping (Error?) -> Void) -> Void = { _ in }
    private let grayToneColor = UIColor(white: 59/255, alpha: 1)

    // MARK: - Public Functions
    
    /// Initializes an instance of DashboardFollowAnAthleteErrorView from the nib file
    ///
    /// - Returns: An instance of DashboardFollowAnAthleteErrorView
    func initFromNib(with onTap: @escaping (@escaping (Error?) -> Void) -> Void) -> DashboardFollowAnAthleteErrorView? {
        guard let view = UINib(nibName: String(describing: DashboardFollowAnAthleteErrorView.self), bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as? DashboardFollowAnAthleteErrorView else {
                return nil
        }
        view.refreshButton.layer.cornerRadius = 2
        view.refreshButton.applyBorder(withColor: StyleColumn.c4.color, borderWidth: 1)
        view.tapAction = onTap
        view.refreshButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)

        return view
    }

    @objc private func didTap() {
        refreshButton.isUserInteractionEnabled = false
        refreshButton.showLoading(withColor: grayToneColor)
        tapAction { [weak self] error in
            self?.refreshButton.hideLoading()
            self?.refreshButton.isUserInteractionEnabled = true
            guard error == nil else {
                return
            }

            UIView.animate(withDuration: 0.3, animations: {
                self?.alpha = 0
            }, completion: { _ in
                self?.removeFromSuperview()
            })
        }
    }

}
