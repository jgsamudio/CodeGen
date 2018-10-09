//
//  BaseViewController.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/11/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit
import Simcoe

/// Includes common UI aspects that all the view controllers need
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Simcoe.track(event: .trackScreen,
                     withAdditionalProperties: [AnalyticsKey.Property.className: String(describing: type(of: self))],
                     on: AnalyticsKey.getScreen(for: self))
        
        /// Reset the back button title to empty
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    /// Show random emoji for features in development
    func showEmoji() {
        let alert = UIAlertController(title: "", message: .randomEmoji(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Almost there!", style: .default) { _ in
            alert.dismiss(animated: true)
        })
        present(alert, animated: true)
    }

    /// Transitions to home screen with animation
    func animateToHomeScreen() {
        UIView.fadePresentedViewController(to: RootViewBuilder().build())
    }

}
