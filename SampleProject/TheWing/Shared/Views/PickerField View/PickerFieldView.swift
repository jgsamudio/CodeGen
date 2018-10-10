//
//  PickerFieldView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class PickerFieldView: BuildableView {
    
    // MARK: - Public Properties
    
    weak var delegate: PickerFieldDelegate?
    
    // MARK: - Private Properties
    
    private lazy var textView: UnderlinedFloatLabeledTextView = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldSelected))
        let textView = UnderlinedFloatLabeledTextView(placeholder: placeholder,
                                                      floatingTitle: floatingTitle,
                                                      theme: theme,
                                                      gesture: tapGesture)
        textView.delegate = self
        return textView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "arrow"))
        imageView.contentMode = .center
        return imageView
    }()
    
    private let placeholder: String
    private let floatingTitle: String
    
    // MARK: - Initialization
    
    init(placeholder: String, floatingTitle: String, theme: Theme) {
        self.placeholder = placeholder
        self.floatingTitle = floatingTitle
        super.init(theme: theme)
        setupDesign()
        setupAccessibility()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets the text with the given parameter.
    ///
    /// - Parameter text: Text to display.
    func set(text: String) {
        textView.set(text)
        setupAccessibility()
    }
    
    /// Updates the arrow of the field
    ///
    /// - Parameter visible: Flag if the picker view is visible.
    func updateArrow(pickerVisible: Bool ) {
        rotateImageView(visible: pickerVisible)
    }
    
}

// MARK: - Private Functions
private extension PickerFieldView {
    
    func setupDesign() {
        backgroundColor =  theme.colorTheme.invertTertiary
        setupTextField()
        setupImageView()
    }
    
    func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityLabel = floatingTitle
        accessibilityValue = textView.textView.text
        accessibilityTraits = UIAccessibilityTraitButton
        accessibilityHint = "ACCESSIBILITY_PICKER_HINTS".localized(comment: "Pick an option")
    }
    
    func setupTextField() {
        addSubview(textView)
        
        let gutter = ViewConstants.defaultGutter
        let insets = UIEdgeInsets(top: 0, left: gutter, bottom: 0, right: gutter)
        textView.autoPinEdgesToSuperviewEdges(with: insets)
    }
    
    func setupImageView() {
        addSubview(imageView)
        imageView.autoSetDimensions(to: CGSize(width: 16, height: 16))
        imageView.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -ViewConstants.defaultGutter)
        imageView.autoAlignAxis(.horizontal, toSameAxisOf: self)
        rotateImageView(visible: false)
    }
    
    private func rotateImageView(visible: Bool) {
        let angle: CGFloat = visible ? CGFloat.pi : (CGFloat.pi * 2)
        UIView.animate(withDuration: AnimationConstants.fastAnimationDuration) {
            self.imageView.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    @objc func textFieldSelected() {
        rotateImageView(visible: true)
        delegate?.didSelectField()
    }
    
}

// MARK: - UnderlinedFloatLabeledTextViewDelegate
extension PickerFieldView: UnderlinedFloatLabeledTextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    
}
