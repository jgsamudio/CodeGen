//
//  StyleableButton.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/21/17.
//  Copyright © Prolific Interactive. All rights reserved.
//

import UIKit

final class StyleableButton: UIButton, Styleable {

    // MARK: - Public Properties
    
    /// Activity indicator of the button
    var activityIndicator: UIActivityIndicatorView!
    /// Original text/title of the button
    var originalButtonText: String!

    @IBInspectable var row: Int = 1 {
        didSet {
            applyStyle()
        }
    }

    @IBInspectable var column: Int = 1 {
        didSet {
            applyStyle()
        }
    }

    /// Represnts the weight attribute of the style guide
    /// Regular, Light, Medium, Bold
    @IBInspectable var weight: Int = 1 {
        didSet {
            applyStyle()
        }
    }

    /// Stlye row for the inactive state.
    @IBInspectable var inactiveRow: Int = 1 {
        didSet {
            applyStyle()
        }
    }

    /// Stlye column for the inactive state.
    @IBInspectable var inactiveColumn: Int = 1 {
        didSet {
            applyStyle()
        }
    }

    /// Stlye weight for the inactive state.
    @IBInspectable var inactiveWeight: Int = 1 {
        didSet {
            applyStyle()
        }
    }

    // MARK: - Public Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyle()
        prepareForDynamicType()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyStyle()
    }

    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title, for: state)
        applyStyle()
    }

    func applyStyle() {
        layer.cornerRadius = 2
        switch state {
        case UIControlState.disabled:
            setAttributedTitle(NSAttributedString(string: title(for: .disabled) ?? "",
                                                  attributes: StyleGuide.shared.style(row: inactiveRow,
                                                                                      column: inactiveColumn,
                                                                                      weight: inactiveWeight)),
                               for: .disabled)
        default:
            setAttributedTitle(NSAttributedString(string: title(for: .normal) ?? "",
                                                  attributes: StyleGuide.shared.style(row: row,
                                                                                      column: column,
                                                                                      weight: weight)),
                               for: .normal)
        }
    }

}
