//
//  StyleableSegmentControl.swift
//  CrossFit Games
//
//  Created by Malinka S on 11/2/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

final class StyleableSegmentControl: UISegmentedControl, Styleable {

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

    @IBInspectable var selectedRow: Int = 1 {
        didSet {
            applyStyle()
        }
    }

    @IBInspectable var selectedColumn: Int = 1 {
        didSet {
            applyStyle()
        }
    }

    @IBInspectable var selectedWeight: Int = 1 {
        didSet {
            applyStyle()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyle()
        prepareForDynamicType()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyStyle()
    }

    override func setTitle(_ title: String?, forSegmentAt segment: Int) {
        super.setTitle(title, forSegmentAt: segment)
        applyStyle()
    }

    func applyStyle() {
        var attributes = attributesForState()
        if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle {
            let mutableParagraphStyle = NSMutableParagraphStyle()
            mutableParagraphStyle.setParagraphStyle(paragraphStyle)
            mutableParagraphStyle.lineSpacing = 0
            attributes[.paragraphStyle] = mutableParagraphStyle
        }

        switch state {
        case UIControlState.selected:
            setTitleTextAttributes(attributes, for: .selected)
        default:
            setTitleTextAttributes(attributes, for: .normal)
        }
    }

    private func attributesForState() -> [NSAttributedStringKey: Any] {
        switch state {
        case UIControlState.selected:
            return StyleGuide.shared.style(row: selectedRow,
                                           column: selectedColumn,
                                           weight: selectedWeight)
        default:
            return StyleGuide.shared.style(row: row,
                                           column: column,
                                           weight: weight)
        }
    }

}
