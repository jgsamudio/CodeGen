//
//  StyleableTextField.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/21/17.
//  Copyright © Prolific Interactive. All rights reserved.
//

import UIKit

final class StyleableTextField: UITextField, Styleable {

    let rightImageView = UIImageView(image: UIImage(named: "checkmark"))
    let padding = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)

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

    /// Stlye row for the placeholder attributes.
    @IBInspectable var placeholderRow: Int = 1 {
        didSet {
            applyStyle()
        }
    }

    /// Stlye column for the placeholder attributes.
    @IBInspectable var placeholderColumn: Int = 1 {
        didSet {
            applyStyle()
        }
    }

    /// Stlye weight for the placeholder attributes.
    @IBInspectable var placeholderWeight: Int = 1 {
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

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    /// Adds a right view to the text field
    /// with a check image
    func addRightView() {
        rightViewMode = .always
        rightImageView.contentMode = .scaleAspectFit
        rightView = rightImageView
    }

    /// Removes the right view
    func removeRightView() {
        rightView = UIView()
    }

    /// Adds a border to the bottom of the text field
    ///
    /// - Parameter color: prefferred color
    func addBottomBorder(color: UIColor = .white) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0,
                              y: frame.size.height - width,
                              width: frame.size.width,
                              height: frame.size.height)

        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
    }

    func applyStyle() {
        let alignment = textAlignment
        var attributes: [String: Any] = [:]

        StyleGuide.shared.style(row: row, column: column, weight: weight).forEach {
            attributes[$0.0.rawValue] = $0.1
        }

        defaultTextAttributes = attributes

        let placeholderAttributes = StyleGuide.shared.style(row: placeholderRow,
                                                            column: placeholderColumn,
                                                            weight: placeholderWeight)
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: placeholderAttributes)
        textAlignment = alignment
    }

}
