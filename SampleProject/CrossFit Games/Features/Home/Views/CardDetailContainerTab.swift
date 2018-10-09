//
//  CardDetailContainerTab.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/13/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// View for showing a title on the container view for card details.
final class CardDetailContainerTab: UIView {

    @IBOutlet private weak var label: UILabel!

    @IBOutlet private weak var underlineView: UIView!

    private let minAlphaLabel: CGFloat = 0.3

    private let minAlphaUnderline: CGFloat = 0

    /// Title to be displayed in `self`.
    var title: String? {
        didSet {
            label.text = title
            hideLineIfTitleEmpty()
            layoutIfNeeded()
        }
    }

    /// Alpha factor (in [0, 1]) for the content displayed in `self`.
    var contentAlpha: CGFloat = 1 {
        didSet {
            label.alpha = contentAlpha * (1 - minAlphaLabel) + minAlphaLabel
            underlineView.alpha = contentAlpha * (1 - minAlphaUnderline) + minAlphaUnderline
            hideLineIfTitleEmpty()
        }
    }

    private func hideLineIfTitleEmpty() {
        if title?.isEmpty ?? true {
            underlineView.alpha = 0
        }
    }

}
