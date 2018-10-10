//
//  UnderlinedFloatLabeledTextView.swift
//  TheWing
//
//  Created by Ruchi Jain on 4/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import JVFloatLabeledTextField

final class UnderlinedFloatLabeledTextView: UIView {
    
    // MARK: - Public Properties
    
    var containsError: Bool = false {
        didSet {
            updateUnderlineColor()
            updateHelperTextColor()
        }
    }
    
    var isActive: Bool {
        return textView.isFirstResponder
    }
    
    var characterCount: Int {
        guard let text = textView.text else {
            return 0
        }
        
        return text.count
    }
    
    var delegate: UnderlinedFloatLabeledTextViewDelegate? {
        didSet {
            textView.delegate = delegate
        }
    }

    lazy var textView: JVFloatLabeledTextView = {
        return FloatLabeledTextFieldBuilder.buildTextView(placeholder: placeholder,
                                                          floatingTitle: floatingTitle,
                                                          theme: theme)
    }()
    
    // MARK: - Private Properties
    
    private let theme: Theme
    
    private let placeholder: String?
    
    private let floatingTitle: String?
    
    private var underlineHeightConstraint: NSLayoutConstraint?
    
    private var textViewHeightConstraint: NSLayoutConstraint?
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(frame: CGRect.zero)
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var underline: UIView = {
        let line = UIView()
        line.backgroundColor = theme.colorTheme.tertiary
        return line
    }()
    
    private lazy var helperLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    // MARK: - Constants
    
    private static let minTextViewHeight: CGFloat = 55
    
    private static let maxTextViewHeight: CGFloat = 208.0
    
    // MARK: - Initialization
    
    /// Instantiates an underlined float labeled text field.
    ///
    /// - Parameters:
    ///   - placeholder: Placeholder text.
    ///   - floatingTitle: Title for floating label.
    ///   - theme: Theme.
    init(placeholder: String?, floatingTitle: String?, theme: Theme) {
        self.placeholder = placeholder
        self.floatingTitle = floatingTitle
        self.theme = theme
        
        super.init(frame: CGRect.zero)
        setupDesign()
        isAccessibilityElement = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    /// Custom init to allow a tap gesture to be called.
    ///
    /// - Parameters:
    ///   - placeholder: Placeholder text
    ///   - floatingTitle: Title for floating label
    ///   - theme: Theme of the application.
    ///   - gesture: Gesture to be added to the view.
    convenience init(placeholder: String?, floatingTitle: String? = nil, theme: Theme, gesture: UIGestureRecognizer) {
        self.init(placeholder: placeholder, floatingTitle: floatingTitle, theme: theme)
        textView.isUserInteractionEnabled = false
        addGestureRecognizer(gesture)
    }
    
    // MARK: - Public Functions
    
    /// Sets the text in the textfield.
    ///
    /// - Parameter text: Optional text.
    func set(_ text: String?) {
        let textStyle = theme.textStyleTheme.bodyNormal.withColor(theme.colorTheme.emphasisQuintary)
        textView.setText(text ?? "", using: textStyle)
        textViewHeightConstraint?.constant = min(textViewContentHeight(),
                                                 UnderlinedFloatLabeledTextView.maxTextViewHeight)
    }

    /// Updates underline view to reflect activation.
    func activateUnderline() {
        updateUnderline()
    }
    
    /// Updates underline view to reflect deactivation.
    func deactivateUnderline() {
        updateUnderline()
    }

    /// Shows in line helper message.
    ///
    /// - Parameter message: Message string.
    func showHelper(_ message: String) {
        let color = containsError ? theme.colorTheme.errorPrimary : theme.colorTheme.tertiary
        let textStyle = theme.textStyleTheme.subheadlineLarge.withColor(color)
        helperLabel.setText(message, using: textStyle.withLineSpacing(0))
        
        if helperLabel.isHidden {
            animateHelper(show: true)
        }
    }
    
    /// Hides in line error.
    func hideHelper() {
        animateHelper(show: false)
    }
    
    /// Updates underline.
    func updateUnderline() {
        updateUnderlineColor()
        let defaultHeight = ViewConstants.lineSeparatorThickness
        let maxHeight: CGFloat = 1.0
        underlineHeightConstraint?.constant = isActive ? maxHeight : defaultHeight
    }
    
}

// MARK: - Private Functions
private extension UnderlinedFloatLabeledTextView {
    
    func setupDesign() {
        addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: 14, right: 0))
        setupTextView()
        setupUnderline()
        setupHelperLabel()
    }
    
    func setupTextView() {
        stackView.addArrangedSubview(textView)
        textViewHeightConstraint = textView.autoSetDimension(.height,
                                                             toSize: UnderlinedFloatLabeledTextView.minTextViewHeight)
    }
    
    func setupUnderline() {
        stackView.addArrangedSubview(underline)
        underlineHeightConstraint = underline.autoSetDimension(.height,
                                                               toSize: ViewConstants.lineSeparatorThickness)
    }

    func setupHelperLabel() {
        stackView.addArrangedSubview(helperLabel)
        helperLabel.autoSetDimension(.height, toSize: 18.0)
    }
    
    func animateHelper(show: Bool) {
        helperLabel.isHidden = !show
        UIView.animate(withDuration: AnimationConstants.defaultDuration, animations: {
            self.helperLabel.alpha = show ? 1 : 0
            self.updateUnderline()
        })
    }
    
    func updateHelperTextColor() {
        guard let text = helperLabel.text else {
            return
        }
        
        let color: UIColor = containsError ? theme.colorTheme.errorPrimary : theme.colorTheme.tertiary
        let textStyle = theme.textStyleTheme.subheadlineLarge.withColor(color)
        helperLabel.setText(text, using: textStyle.withLineSpacing(0))
    }
    
    func updateUnderlineColor() {
        switch (!containsError, isActive) {
        case (true, true):
            underline.backgroundColor = theme.colorTheme.emphasisQuintary
        case (true, false):
            underline.backgroundColor = theme.colorTheme.tertiary
        case (false, _):
            underline.backgroundColor = theme.colorTheme.errorPrimary
        }
    }
    
    func textViewContentHeight() -> CGFloat {
        let width = UIScreen.width - (2 * ViewConstants.defaultGutter)
        return textView.heightForWidth(width)
    }
    
}
