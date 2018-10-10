//
//  EditSocialLinksView.swift
//  TheWing
//
//  Created by Ruchi Jain on 4/2/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class EditSocialLinksView: UIView {

    // MARK: - Public Properties

    weak var delegate: EditSocialLinksDelegate?

    /// Form field delegate.
    weak var formDelegate: FormDelegate?
    
    // MARK: - Private Properties
    
    private let theme: Theme
    
    private var gutter: CGFloat
    
    private lazy var textFields: [SocialType: UnderlinedFloatLabeledTextField] = {
        var textFields = [SocialType: UnderlinedFloatLabeledTextField]()
        textFields[SocialType.web] = websiteTextField
        textFields[SocialType.instagram] = instagramTextField
        textFields[SocialType.facebook] = facebookTextField
        textFields[SocialType.twitter] = twitterTextField
        return textFields
    }()
    
    private lazy var websiteTextField: UnderlinedFloatLabeledTextField = {
        let placeholder = "ADD_YOUR_WEBSITE".localized(comment: "Add your website.")
        let title = "WEBSITE".localized(comment: "Website")
        let textField = UnderlinedFloatLabeledTextField(placeholder: placeholder, floatingTitle: title, theme: theme)
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.delegate = self
        textField.set(image: #imageLiteral(resourceName: "web_icon"))
        textField.textField.placeholderColor = theme.colorTheme.tertiary
        return textField
    }()
    
    private lazy var instagramTextField: UnderlinedFloatLabeledTextField = {
        let placeholder = "ADD_YOUR_INSTAGRAM".localized(comment: "Add your instagram.")
        let title = "INSTAGRAM".localized(comment: "Instagram")
        let textField = UnderlinedFloatLabeledTextField(placeholder: placeholder, floatingTitle: title, theme: theme)
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.delegate = self
        textField.set(image: #imageLiteral(resourceName: "instagram_icon"))
        textField.textField.placeholderColor = theme.colorTheme.tertiary
        return textField
    }()
    
    private lazy var facebookTextField: UnderlinedFloatLabeledTextField = {
        let placeholder = "ADD_YOUR_FACEBOOK".localized(comment: "Add your facebook.")
        let title = "FACEBOOK".localized(comment: "Facebook")
        let textField = UnderlinedFloatLabeledTextField(placeholder: placeholder, floatingTitle: title, theme: theme)
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.delegate = self
        textField.set(image: #imageLiteral(resourceName: "facebook_icon"))
        textField.textField.placeholderColor = theme.colorTheme.tertiary
        return textField
    }()
    
    private lazy var twitterTextField: UnderlinedFloatLabeledTextField = {
        let placeholder = "ADD_YOUR_TWITTER".localized(comment: "Add your twitter.")
        let title = "TWITTER".localized(comment: "Twitter")
        let textField = UnderlinedFloatLabeledTextField(placeholder: placeholder, floatingTitle: title, theme: theme)
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.delegate = self
        textField.set(image: #imageLiteral(resourceName: "twitter_icon"))
        textField.textField.placeholderColor = theme.colorTheme.tertiary
        return textField
    }()
    
    // MARK: - Initialization
    
    init(theme: Theme, gutter: CGFloat = ViewConstants.defaultGutter) {
        self.theme = theme
        self.gutter = gutter
        super.init(frame: CGRect.zero)
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions
    
    /// Sets the corresponding text fields with social information.
    ///
    /// - Parameters:
    ///   - web: Website.
    ///   - instagram: Instagram handle.
    ///   - facebook: Facebook username.
    ///   - twitter: Twitter handle.
    func set(web: String?, instagram: String?, facebook: String?, twitter: String?) {
        websiteTextField.set(web)
        instagramTextField.set(instagram)
        facebookTextField.set(facebook)
        twitterTextField.set(twitter)
    }
    
    /// Shows error message in textfield at given index.
    ///
    /// - Parameters:
    ///   - socialType: Social link type.
    ///   - errorMessage: Error message.
    func showError(in socialType: SocialType, errorMessage: String) {
        guard let textField = textFields[socialType] else {
            return
        }
        
        textField.showError(errorMessage)
    }
    
    /// Hides any error showing error in textfield at given index.
    ///
    /// - Parameter socialType: Social link type.
    func hideError(in socialType: SocialType) {
        guard let textField = textFields[socialType] else {
            return
        }
        
        textField.hideError()
    }
    
}

// MARK: - Private Functions
private extension EditSocialLinksView {
    
    func setupDesign() {
        let insets = UIEdgeInsets(top: 0, left: gutter, bottom: 0, right: gutter)
        let spacing: CGFloat = 0
        
        addSubview(websiteTextField)
        websiteTextField.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .bottom)
        
        addSubview(instagramTextField)
        instagramTextField.autoPinEdge(toSuperviewEdge: .leading, withInset: gutter)
        instagramTextField.autoPinEdge(toSuperviewEdge: .trailing, withInset: gutter)
        instagramTextField.autoPinEdge(.top, to: .bottom, of: websiteTextField, withOffset: spacing)
        
        addSubview(facebookTextField)
        facebookTextField.autoPinEdge(toSuperviewEdge: .leading, withInset: gutter)
        facebookTextField.autoPinEdge(toSuperviewEdge: .trailing, withInset: gutter)
        facebookTextField.autoPinEdge(.top, to: .bottom, of: instagramTextField, withOffset: spacing)
        
        addSubview(twitterTextField)
        twitterTextField.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .top)
        twitterTextField.autoPinEdge(.top, to: .bottom, of: facebookTextField, withOffset: spacing)
    }

}

// MARK: - UnderlinedFloatLabeledTextFieldDelegate
extension EditSocialLinksView: UnderlinedFloatLabeledTextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        formDelegate?.didEnterField()

        switch textField {
        case websiteTextField.textField:
            websiteTextField.hideError()
            websiteTextField.activateUnderline()
        case instagramTextField.textField:
            instagramTextField.activateUnderline()
        case facebookTextField.textField:
            facebookTextField.activateUnderline()
        case twitterTextField.textField:
            twitterTextField.activateUnderline()
        default:
            fatalError("Unknown UITextField instance")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case websiteTextField.textField:
            websiteTextField.deactivateUnderline()
            delegate?.websiteUpdated(link: textField.text)
        case instagramTextField.textField:
            instagramTextField.deactivateUnderline()
            delegate?.instagramUpdated(username: textField.text)
        case facebookTextField.textField:
            facebookTextField.deactivateUnderline()
            delegate?.facebookUpdated(username: textField.text)
        case twitterTextField.textField:
            twitterTextField.deactivateUnderline()
            delegate?.twitterUpdated(username: textField.text)
        default:
            fatalError("Unknown UITextField instance")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}

// MARK: - FormField
extension EditSocialLinksView: FormField {

    func resignFirstResponder() {
        if websiteTextField.textField.isFirstResponder {
            websiteTextField.textField.resignFirstResponder()
        } else if instagramTextField.textField.isFirstResponder {
            instagramTextField.textField.resignFirstResponder()
        } else if facebookTextField.textField.isFirstResponder {
            facebookTextField.textField.resignFirstResponder()
        } else if twitterTextField.textField.isFirstResponder {
            twitterTextField.textField.resignFirstResponder()
        }
    }

}
