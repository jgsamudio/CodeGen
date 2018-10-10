//
//  UnderlinedFloatLabeledTextField.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import JVFloatLabeledTextField

/// Textfield with underline and floating placeholder label.
final class UnderlinedFloatLabeledTextField: BuildableView {
    
    // MARK: - Public Properties
    
    var autocapitalizationType: UITextAutocapitalizationType = .sentences {
        didSet {
            textField.autocapitalizationType = autocapitalizationType
        }
    }
    
    /// Delegate.
    var delegate: UnderlinedFloatLabeledTextFieldDelegate? {
        didSet {
            textField.delegate = delegate
        }
    }
    
    /// Should text be secured.
    var isSecureTextEntry: Bool = false {
        didSet {
            textField.isSecureTextEntry = isSecureTextEntry
            let tmpString = textField.text
            textField.text = " "
            textField.text = tmpString
        }
    }
    
    /// Keyboard type.
    var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }

    /// Return key type.
    var returnKeyType: UIReturnKeyType = .default {
        didSet {
            textField.returnKeyType = returnKeyType
        }
    }
    
    /// Float labeled text field.
    lazy var textField: JVFloatLabeledTextField = {
        let textField = FloatLabeledTextFieldBuilder.buildTextField(placeholder: placeholder,
                                                                    floatingTitle: floatingTitle,
                                                                    theme: theme)
        textField.isAccessibilityElement = true
        textField.accessibilityLabel = floatingTitle ?? placeholder
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    // MARK: - Private Properties
    
    private let placeholder: String?
    
    private let floatingTitle: String?
    
    private var underlineHeightConstraint: NSLayoutConstraint?
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(frame: CGRect.zero)
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let stack = UIStackView(frame: CGRect.zero)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.spacing = 16
        return stack
    }()
    
    private lazy var accessoryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(accessoryButtonSelected), for: .touchUpInside)
        button.autoSetDimension(.width, toSize: 44)
        button.isHidden = true
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.autoSetDimension(.width, toSize: 20)
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var underline: UIView = {
        let line = UIView()
        line.backgroundColor = theme.colorTheme.tertiary
        return line
    }()
    
    // MARK: - Initialization
    
    /// Instantiates an underlined float labeled text field.
    ///
    /// - Parameters:
    ///   - placeholder: Placeholder text.
    ///   - floatingTitle: Title for floating label.
    ///   - theme: Theme.
    init(placeholder: String?, floatingTitle: String? = nil, theme: Theme) {
        self.placeholder = placeholder
        self.floatingTitle = floatingTitle
        super.init(theme: theme)
        setupDesign()
    }

    /// Custom init to allow a tap gesture to be called.
    ///
    /// - Parameters:
    ///   - placeholder: Placeholder text
    ///   - floatingTitle: Title for floating label
    ///   - gesture: Gesture to be added to the view.
    ///   - theme: Theme of the application.
    convenience init(placeholder: String?, floatingTitle: String? = nil, gesture: UIGestureRecognizer, theme: Theme) {
        self.init(placeholder: placeholder, floatingTitle: floatingTitle, theme: theme)
        textField.isUserInteractionEnabled = false
        addGestureRecognizer(gesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Public Functions
    
    /// Updates underline view to reflect activation.
    func activateUnderline() {
        updateUnderline(isActive: true, containsError: !errorLabel.isHidden)
    }
    
    /// Updates underline view to reflect deactivation.
    func deactivateUnderline() {
        updateUnderline(isActive: false, containsError: !errorLabel.isHidden)
    }
    
    /// Shows in line error message.
    ///
    /// - Parameter message: Error string.
    func showError(_ message: String) {
        let textStyle = theme.textStyleTheme.subheadlineLarge.withColor(theme.colorTheme.errorPrimary)
        errorLabel.setText(message, using: textStyle.withLineSpacing(0))
        
        animateErrorLabel(showError: true)
    }
    
    /// Hides in line error.
    func hideError() {
        animateErrorLabel(showError: false)
    }
    
    /// Sets the text in the textfield.
    ///
    /// - Parameter text: Optional text.
    func set(_ text: String?) {
        textField.text = text
    }
    
    /// Sets the accessory image of the accessory button.
    ///
    /// - Parameters:
    ///   - accessoryImage: Image to set on the button.
    ///   - accessibilityLabel: Accessibility label for accessory button.
    func set(accessoryImage: UIImage?, accessibilityLabel: String? = nil) {
        accessoryButton.isHidden = (accessoryImage == nil)
        accessoryButton.setImage(accessoryImage, for: .normal)
        accessoryButton.accessibilityLabel = accessibilityLabel
    }
    
    /// Sets the image of the descriptive image view.
    ///
    /// - Parameter image: Image.
    func set(image: UIImage?) {
        imageView.isHidden = (image == nil)
        imageView.image = image
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return textField.becomeFirstResponder()
    }
    
    @discardableResult override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return textField.resignFirstResponder()
    }

}

// MARK: - Private Functions
private extension UnderlinedFloatLabeledTextField {
    
    func setupDesign() {
        addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: 14, right: 0))
        setupFloatLabeledTextField()
        setupUnderline()
        setupErrorLabel()
    }
    
    func setupFloatLabeledTextField() {
        stackView.addArrangedSubview(textFieldStackView)
        textFieldStackView.addArrangedSubview(imageView)
        textFieldStackView.addArrangedSubview(textField)
        textFieldStackView.addArrangedSubview(accessoryButton)
        textFieldStackView.autoSetDimension(.height, toSize: 55.0)
    }
    
    func setupUnderline() {
        stackView.addArrangedSubview(underline)
        underlineHeightConstraint = underline.autoSetDimension(.height,
                                                               toSize: ViewConstants.lineSeparatorThickness)
    }
    
    func setupErrorLabel() {
        stackView.addArrangedSubview(errorLabel)
    }
    
    func updateUnderline(isActive: Bool, containsError: Bool) {
        updateUnderlineColor(containsError: containsError, isActive: isActive)
        
        let defaultHeight = ViewConstants.lineSeparatorThickness
        let maxHeight: CGFloat = 1.0
        underlineHeightConstraint?.constant = isActive ? maxHeight : defaultHeight
    }
    
    func animateErrorLabel(showError: Bool) {
        errorLabel.isHidden = !showError
        UIView.animate(withDuration: AnimationConstants.defaultDuration, animations: {
            self.errorLabel.alpha = showError ? 1 : 0
            self.updateUnderline(isActive: self.textField.isEditing, containsError: showError)
        })
    }
    
    func updateUnderlineColor(containsError: Bool, isActive: Bool) {
        switch (!containsError, isActive) {
        case (true, true):
            underline.backgroundColor = theme.colorTheme.emphasisQuintary
        case (true, false):
            underline.backgroundColor = theme.colorTheme.tertiary
        case (false, _):
            underline.backgroundColor = theme.colorTheme.errorPrimary
        }
    }
    
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        delegate?.textFieldEditingChanged(textField)
    }
    
    @objc func accessoryButtonSelected() {
        delegate?.accessoryButtonSelected()
    }
    
}
