//
//  DashboardPromoItem.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 2/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// View to display in the stack view used for button items on the dashboard screen.
final class DashboardPromoItem: UIView {

    @IBOutlet private weak var label: UILabel!

    /// Text displayed on `self`.
    var text: String? {
        didSet {
            label.text = text
        }
    }

    /// Action that is performed when a user taps on `self`.
    var tapAction: () -> Void = {}

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupForStoryboardUse()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /// Triggers `tapAction` and can be used as selector for a gesture recognizer.
    @objc func triggerTap() {
        tapAction()
    }

}
