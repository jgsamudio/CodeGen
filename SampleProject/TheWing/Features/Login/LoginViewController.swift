//
//  LoginViewController.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class LoginViewController: BuildableViewController {
    
    // MARK: - Public Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// Login view model.
    var viewModel: LoginViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    /// Login delegate for handling login updates.
    weak var delegate: LoginDelegate?
    
    // MARK: - Private Properties
    
    private var isKeyboardPresent = false
    
    private lazy var backgroundView: UIImageView = {
        let backgroundView = UIImageView(image: #imageLiteral(resourceName: "wing_splash_image"))
        backgroundView.contentMode = .scaleAspectFill
        return backgroundView
    }()
    
    private lazy var logoIconView: UIImageView = {
        let logoIconView = UIImageView(image: #imageLiteral(resourceName: "wing_logo_pink"))
        logoIconView.contentMode = .scaleAspectFit
        logoIconView.frame.size = LoginViewController.logoFrameSize
        logoIconView.center.x = view.center.x
        logoIconView.center.y = view.center.y * 0.89
        logoIconView.isAccessibilityElement = true
        logoIconView.accessibilityLabel = "ACCESSIBILITY_LOGIN_VIEW_TITLE".localized(comment: "Login")
        logoIconView.accessibilityTraits = UIAccessibilityTraitHeader
        return logoIconView
    }()
    
    private lazy var loginView: UIView = {
        let loginView = UIView()
        loginView.backgroundColor = theme.colorTheme.secondary
        loginView.frame.size = CGSize(width: UIScreen.width,
                                      height: UIScreen.height)
        loginView.center.x = view.center.x
        loginView.frame.origin.y = UIScreen.height
        return loginView
    }()
    
    private var loginFieldHeight: CGFloat = {
        let loginViewHeight = UIScreen.height - LoginViewController.logoViewHeight
        let footerHeight: CGFloat = UIScreen.isiPhoneXOrBigger ? 80 : 60
        return loginViewHeight - footerHeight
    }()
    
    private lazy var loginFieldView: UIView = {
        let loginFieldView = UIView()
        loginFieldView.frame.size.width = UIScreen.width
        loginFieldView.frame.size.height = loginFieldHeight
        return loginFieldView
    }()
    
    private lazy var emailTextField: UnderlinedFloatLabeledTextField = {
        let label = "EMAIL_TITLE".localized(comment: "Email")
        let textField = UnderlinedFloatLabeledTextField(placeholder: label,
                                                        floatingTitle: label,
                                                        theme: theme)
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.delegate = self
        return textField
    }()
    
    private lazy var passwordTextField: UnderlinedFloatLabeledTextField = {
        let label = "PASSWORD_TITLE".localized(comment: "Password")
        let textField = UnderlinedFloatLabeledTextField(placeholder: label,
                                                        floatingTitle: label,
                                                        theme: theme)
        setAccessoryImage(passwordTextField: textField, isSecureTextEntry: true)
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.delegate = self
        return textField
    }()

    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.addTarget(viewModel, action: #selector(viewModel.forgotPasswordSelected), for: .touchUpInside)
        button.setTitleText("FORGOT_PASSWORD_TITLE".localized(comment: "Forgot Password?"),
                            using: theme.textStyleTheme.bodySmall.withColor(theme.colorTheme.emphasisPrimary))
        return button
    }()
    
    private lazy var loginButton: StylizedButton = {
        let button = StylizedButton(buttonStyle: theme.buttonStyleTheme.primaryDarkButtonStyle)
        button.setTitle("LOG_IN_TITLE".localized(comment: "Log In").uppercased(), for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        button.accessibilityHint = viewModel.validationStateAccessibilityHint()
        return button
    }()
    
    private lazy var contactUsView: ContactUsView = {
        let contactUsView = ContactUsView(theme: theme)
        contactUsView.autoSetDimension(.height, toSize: 44)
        contactUsView.delegate = self
        return contactUsView
    }()
    
    private lazy var loginFooterView: LoginFooterView = {
        let loginFooterView = LoginFooterView(theme: theme)
        let height: CGFloat = UIScreen.isiPhoneXOrBigger ? 80 : 60
        loginFooterView.autoSetDimension(.height, toSize: height)
        loginFooterView.delegate = self
        return loginFooterView
    }()

    // MARK: - Constants
    
    fileprivate static let logoWidth: CGFloat = UIScreen.width * 0.23
    fileprivate static let logoHeight: CGFloat = UIScreen.height * 0.085
    fileprivate static let logoFrameSize = CGSize(width: LoginViewController.logoWidth,
                                                  height: LoginViewController.logoHeight)
    fileprivate static let logoYInLogoViewMultiplier: CGFloat = 0.35
    fileprivate static let logoViewHeight: CGFloat = UIScreen.height * 0.34
    fileprivate static let logoViewHeightWithKeyboard: CGFloat = UIScreen.height * 0.2
    fileprivate static let logoViewHeightSmallWithKeyboard: CGFloat = UIScreen.height * 0.095
    
    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        addRecognizerForKeyboardDismissal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }

    // MARK: - KeyboardObserver
    
    override func keyboardWillShow(notification: Notification) {
        isKeyboardPresent = true
        animateSubviews()
    }
    
    override func keyboardWillHide(notification: Notification) {
        isKeyboardPresent = false
        animateSubviews()
    }

}

// MARK: - Private Functions
private extension LoginViewController {
    
    @objc func didTapLoginButton() {
        viewModel.loginUser()
    }
    
    func setupDesign() {
        setupBackgroundView()
        setupLoginView() 
        animateBackgroundView()
        animateSubviews()
    }
    
    func setupBackgroundView() {
        view.addSubview(backgroundView)
        backgroundView.autoPinEdgesToSuperviewEdges()
        backgroundView.addSubview(logoIconView)
    }
    
    func setupLoginView() {
        view.addSubview(loginView)
        setupLoginFieldView()
        setupLoginFooterView()
        setupContactUsView()
    }
    
    func setupLoginFieldView() {
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupForgotPasswordButton()
        loginFieldView.autoSetDimension(.height, toSize: loginFieldHeight)
        loginView.addSubview(loginFieldView)
        loginFieldView.backgroundColor = theme.colorTheme.invertPrimary
        loginFieldView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(), excludingEdge: .bottom)
    }
    
    func setupContactUsView() {
        loginView.addSubview(contactUsView)
        contactUsView.autoPinEdge(.leading, to: .leading, of: loginView)
        contactUsView.autoPinEdge(.trailing, to: .trailing, of: loginView)
        contactUsView.autoPinEdge(.bottom, to: .top, of: loginFooterView)
    }

    func setupLoginFooterView() {
        loginView.addSubview(loginFooterView)
        let topInset = UIEdgeInsets(top: loginFieldView.frame.height, left: 0, bottom: 0, right: 0)
        loginFooterView.autoPinEdgesToSuperviewEdges(with: topInset, excludingEdge: .bottom)
    }
    
    func animateBackgroundView() {
        UIView.animate(withDuration: AnimationConstants.duration) {
            self.backgroundView.image = #imageLiteral(resourceName: "wing_blur_background")
        }
    }
    
    func animateSubviews() {
        if isKeyboardPresent {
            animateSubviewsWithKeyboard()
        } else {
            animateSubviewsWithoutKeyboard()
        }
    }
    
    func animateSubviewsWithoutKeyboard() {
        UIView.animate(withDuration: AnimationConstants.duration) {
            if !UIScreen.isiPhoneXOrBigger {
                self.logoIconView.frame.size = LoginViewController.logoFrameSize
            }

            self.shiftLogoIconViewYPosition(to: LoginViewController.logoViewHeight *
                LoginViewController.logoYInLogoViewMultiplier)
        }
        
        UIView.animate(withDuration: AnimationConstants.duration) {
            self.loginView.frame.origin.y = LoginViewController.logoViewHeight
        }
    }
    
    func animateSubviewsWithKeyboard() {
        let logoViewHeight = UIScreen.isSmall ?
            LoginViewController.logoViewHeightSmallWithKeyboard :
            LoginViewController.logoViewHeightWithKeyboard
        
        UIView.animate(withDuration: AnimationConstants.duration) {
            if !UIScreen.isiPhoneXOrBigger {
                let frame = CGSize(width: LoginViewController.logoWidth * 0.73,
                                   height: LoginViewController.logoHeight * 0.85)
                if UIScreen.isSmall {
                    self.logoIconView.frame.size = CGSize(width: frame.width * 0.47,
                                                          height: frame.height * 0.58)
                } else {
                    self.logoIconView.frame.size = frame
                }
            }
        
            self.shiftLogoIconViewYPosition(to: logoViewHeight * LoginViewController.logoYInLogoViewMultiplier)
        }
        
        UIView.animate(withDuration: AnimationConstants.duration) {
            self.loginView.frame.origin.y = logoViewHeight
        }
    }
    
    func shiftLogoIconViewYPosition(to position: CGFloat) {
        self.logoIconView.center.x = self.view.center.x
        self.logoIconView.frame.origin.y = position
        self.logoIconView.layoutIfNeeded()
    }
    
    func setupEmailTextField() {
        loginFieldView.addSubview(emailTextField)
        let emailTextFieldTopOffset = DeviceMeasurement.value(smallDevices: 24, regularDevices: 38, largeDevices: 42)
        emailTextField.autoPinEdge(.top, to: .top, of: loginFieldView, withOffset: emailTextFieldTopOffset)
        autoPinField(subview: emailTextField)
    }
    
    func setupPasswordTextField() {
        loginFieldView.addSubview(passwordTextField)
        passwordTextField.autoPinEdge(.top, to: .bottom, of: emailTextField)
        autoPinField(subview: passwordTextField)
    }
    
    func setupLoginButton() {
        loginFieldView.addSubview(loginButton)
        let loginButtonTopOffset = DeviceMeasurement.value(smallDevices: 39, regularDevices: 52, largeDevices: 65)
        loginButton.autoPinEdge(.top, to: .bottom, of: passwordTextField, withOffset: loginButtonTopOffset)
        autoPinField(subview: loginButton)
    }
    
    func setupForgotPasswordButton() {
        loginFieldView.addSubview(forgotPasswordButton)
        let forgotPasswordButtonTopOffset = DeviceMeasurement.value(smallDevices: -4, regularDevices: 2, largeDevices: 8)
        forgotPasswordButton.autoPinEdge(.top, to: .bottom, of: passwordTextField, withOffset: forgotPasswordButtonTopOffset)
        forgotPasswordButton.autoAlignAxis(.vertical, toSameAxisOf: passwordTextField)
    }
    
    func autoPinField(subview: UIView) {
        let gutter = DeviceMeasurement.value(smallDevices: 40, regularDevices: 55, largeDevices: 55)
        subview.autoPinEdge(.leading, to: .leading, of: loginFieldView, withOffset: gutter)
        subview.autoPinEdge(.trailing, to: .trailing, of: loginFieldView, withOffset: -gutter)
    }

    func setAccessoryImage(passwordTextField: UnderlinedFloatLabeledTextField, isSecureTextEntry: Bool) {
        let image = isSecureTextEntry ? #imageLiteral(resourceName: "password_show") : #imageLiteral(resourceName: "password_hide")
        let accessibilityLabel = viewModel.showHidePasswordAccessibilityLabel(isPasswordHidden: isSecureTextEntry)
        passwordTextField.set(accessoryImage: image, accessibilityLabel: accessibilityLabel)
    }
    
}

// MARK: - LoginViewDelegate
extension LoginViewController: LoginViewDelegate {
    
    func loginSucceeded() {
        delegate?.userLoggedIn()
    }
    
    func loginFailed(error: Error) {
        let errorMessage = "LOGIN_ERROR_MESSAGE".localized(comment: "Error message")
        let alert = UIAlertController.singleActionAlertController(title: "LOGIN_ERROR".localized(comment: "Login Error"),
                                                                  message: errorMessage)
        present(alert, animated: true, completion: nil)
    }
    
    func emailContactTapped(email: String) {
       presentEmailActionSheet(address: email)
    }
    
    func urlLinkTapped(url: URL) {
        open(url)
    }
    
    func isValidEmail(valid: Bool) {
        let localizedError = "EMAIL_ERROR_MESSAGE".localized(comment: "Email error")
        valid ? emailTextField.hideError() : emailTextField.showError(localizedError)
    }
    
    func isValidPassword(valid: Bool) {
        let localizedError = "PASSWORD_ERROR_MESSAGE".localized(comment: "Password error")
        valid ? passwordTextField.hideError() : passwordTextField.showError(localizedError)
    }
    
    func isLoginValid(valid: Bool) {
        loginButton.isEnabled = valid
        loginButton.accessibilityHint = viewModel.validationStateAccessibilityHint()
    }

    func isLoading(loading: Bool) {
        loginButton.isLoading(loading: loading)
    }

}

// MARK: - ContactUsViewDelegate
extension LoginViewController: ContactUsViewDelegate {
    
    func contactUsSelected() {
        viewModel.selectedContactUs()
    }
    
}

// MARK: - LoginFooterViewDelegate
extension LoginViewController: LoginFooterViewDelegate {
    
    func privacyPolicySelected() {
        viewModel.selectedPrivacyPolicy()
    }
    
    func termsAndConditionsSelected() {
        viewModel.selectedTermsAndConditions()
    }
    
}

// MARK: - UnderlinedFloatLabeledTextFieldDelegate
extension LoginViewController: UnderlinedFloatLabeledTextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField.textField:
            emailTextField.activateUnderline()
        case passwordTextField.textField:
            passwordTextField.activateUnderline()
        default:
            fatalError("Unknown UITextField instance")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField.textField:
            viewModel.emailDidEndEditing()
            emailTextField.deactivateUnderline()
        case passwordTextField.textField:
            passwordTextField.deactivateUnderline()
            viewModel.passwordDidEndEditing()
        default:
            fatalError("Unknown UITextField instance")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField.textField:
            passwordTextField.textField.becomeFirstResponder()
        case passwordTextField.textField:
            textField.resignFirstResponder()
        default:
            fatalError("Unknown UITextField instance")
        }
        
        return true
    }

    func textFieldEditingChanged(_ textField: UITextField) {
        switch textField {
        case emailTextField.textField:
            viewModel.email = textField.text
        case passwordTextField.textField:
            viewModel.password = textField.text
        default:
            fatalError("Unknown UITextField instance")
        }
    }

    func accessoryButtonSelected() {
        setAccessoryImage(passwordTextField: passwordTextField, isSecureTextEntry: !passwordTextField.isSecureTextEntry)
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }   

}
