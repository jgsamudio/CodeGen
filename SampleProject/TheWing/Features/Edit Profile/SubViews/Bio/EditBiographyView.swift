//
//  EditBiographyView.swift
//  TheWing
//
//  Created by Ruchi Jain on 4/3/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EditBiographyView: UIView {
    
    // MARK: - Public Properties
    
    weak var delegate: EditBiographyViewDelegate?

    /// Form field delegate.
    weak var formDelegate: FormDelegate?
    
    // MARK: - Private Properties
    
    private let theme: Theme

    private var containsError: Bool = false {
        didSet {
            bioTextView.containsError = containsError
        }
    }
    
    private let gutter: CGFloat

    private lazy var bioTextView: UnderlinedFloatLabeledTextView = {
        let title = "BIO".localized(comment: "Bio")
        let placeholder = "ADD_YOUR_BIO".localized(comment: "Add your bio").capitalized
        let view = UnderlinedFloatLabeledTextView(placeholder: placeholder, floatingTitle: title, theme: theme)
        view.delegate = self
        view.textView.returnKeyType = .done
        view.accessibilityLabel = title
        return view
    }()
    
    // MARK: - Initialization
    
    init(theme: Theme, delegate: EditBiographyViewDelegate? = nil, gutter: CGFloat = ViewConstants.defaultGutter) {
        self.theme = theme
        self.delegate = delegate
        self.gutter = gutter
        super.init(frame: CGRect.zero)
        
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions

    /// Sets the text of the text view.
    ///
    /// - Parameter text: Optional text
    func set(_ text: String?) {
        bioTextView.set(text)
        bioTextView.accessibilityValue = text
    }
    
    /// Sets view to show error if necessary.
    ///
    /// - Parameter show: True, if should show error, false otherwise.
    func setShowError(_ show: Bool) {
        containsError = show
    }

}

// MARK: - Private Functions
private extension EditBiographyView {
    
    func setupDesign() {
        addSubview(bioTextView)
        let textViewInsets = UIEdgeInsets(top: 0, left: gutter, bottom: 0, right: gutter)
        bioTextView.autoPinEdgesToSuperviewEdges(with: textViewInsets)
    }
    
}

// MARK: - UnderlinedFLoatLabeledTextViewDelegate
// MARK: - UnderlinedFloatLabeledTextViewDelegate
extension EditBiographyView: UnderlinedFloatLabeledTextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        formDelegate?.didEnterField()

        let message = "\(bioTextView.characterCount)/\(BusinessConstants.bioCharacterCountLimit)"
        bioTextView.showHelper(message)
        bioTextView.updateUnderline()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            bioTextView.textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        set(textView.text)
        let message = "\(bioTextView.characterCount)/\(BusinessConstants.bioCharacterCountLimit)"
        bioTextView.showHelper(message)
        containsError = !textView.text.isValidBio
        delegate?.biographyDidChange(textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        bioTextView.updateUnderline()
        
        if !containsError {
            bioTextView.hideHelper()
        }
    }
    
}

// MARK: - FormField
extension EditBiographyView: FormField {

    func resignFirstResponder() {
        if bioTextView.textView.isFirstResponder {
            bioTextView.textView.resignFirstResponder()
        }
    }

}
