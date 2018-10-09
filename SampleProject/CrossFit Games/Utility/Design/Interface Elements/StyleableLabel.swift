//
//  Label.swift
//  StyleGuide
//
//  Created by Daniel Vancura on 9/21/17.
//  Copyright © Prolific Interactive. All rights reserved.
//

import UIKit

class StyleableLabel: UILabel, Styleable {

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

    @IBInspectable var weight: Int = 1 {
        didSet {
            applyStyle()
        }
    }

    @IBInspectable var removeLinespacing: Bool = false {
        didSet {
            applyStyle()
        }
    }

    override var text: String? {
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

    func applyStyle() {
        let alignment = textAlignment
        var attributes = StyleGuide.shared.style(row: row,
                                                 column: column,
                                                 weight: weight)
        if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle {
            let mutableParagraphStyle = NSMutableParagraphStyle()
            mutableParagraphStyle.setParagraphStyle(paragraphStyle)
            mutableParagraphStyle.lineBreakMode = lineBreakMode
            if removeLinespacing {
                mutableParagraphStyle.lineSpacing = 0
            }
            attributes[.paragraphStyle] = mutableParagraphStyle
        }
        attributedText = NSAttributedString(string: text ?? "",
                                            attributes: attributes)
        textAlignment = alignment
    }

    func setSuperscript(withText text: String, withRow superRow: StyleRow, offset: CGFloat = 50) {
        let attributes = StyleGuide.shared.style(row: row,
                                                 column: column,
                                                 weight: weight)
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: attributes)
        if let fontSuper = (attributes[.font] as? UIFont)?.withSize(superRow.fontSize), text.count > 1 {
            attString.addAttributes([NSAttributedStringKey.font: fontSuper, NSAttributedStringKey.baselineOffset: offset],
                                    range: NSRange(location: text.count - 2, length: 2))
            attributedText = attString
        }
    }

}
