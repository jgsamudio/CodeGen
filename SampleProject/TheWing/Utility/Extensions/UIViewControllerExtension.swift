//
//  UIViewControllerExtension.swift
//  TheWing
//
//  Created by Luna An on 3/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    
    // MARK: - Public Functions
    
    /// Opens url from current view controller.
    ///
    /// - Parameter url: URL.
    func open(_ url: URL) {
        guard let correctURL = url.absoluteString.url,
            correctURL.absoluteString.isValidUrl,
            UIApplication.shared.canOpenURL(correctURL) else {
    
    // MARK: - Public Properties
    
                let message = "\(ErrorLocalization.invalidURLMessage) (\(url.absoluteString))"
                let alert = UIAlertController.singleActionAlertController(title: ErrorLocalization.politeErrorTitle,
                                                                          message: message)
                present(alert, animated: true, completion: nil)
                return
        }
        
        let viewController = SFSafariViewController(url: correctURL)
        present(viewController, animated: true, completion: nil)
    }
    
    /// Hides keyboard if tapped outside responder.
    func addRecognizerForKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    /// Dismiss keyboard action.
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// Handler for keyboard will show.
    ///
    /// - Parameter notification: Keyboard will show notification.
    @objc func keyboardWillShow(notification: Notification) {
        // Will be overridden
    }
    
    /// Handler for keyboard will hide.
    ///
    /// - Parameter notification: Keyboard will hide notification.
    @objc func keyboardWillHide(notification: Notification) {
        // Will be overridden
    }
    
    /// Animates the view's constraints.
    func animateConstraints() {
        UIView.animate(withDuration: 0.35) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// Presents alert controller with a single action with given title and message strings when network error occurs.
    ///
    /// - Parameters:
    ///   - error: Network error.
    ///   - animated: Flag to determine if the alert controller should be animated.
    ///   - completion: Completion handler.
    func presentAlertController(withNetworkError error: Error?, animated: Bool = true, completion: (() -> Void)? = nil) {
        present(UIAlertController(withNetworkError: error), animated: animated, completion: completion)
    }
    
    /// Presents photo library permission alert.
    @objc func presentPhotoLibraryPermissionsAlert() {
        let imagePickerValidator = ImagePickerValidator(viewController: self)
        
        let openCamera: () -> Void = {
            imagePickerValidator.checkImagePickerPermissions(.camera)
        }
        
        let openLibrary: () -> Void = {
            imagePickerValidator.checkImagePickerPermissions(.photoLibrary)
        }
        
        let firstOptionTitle = "TAKE_PHOTO".localized(comment: "Take Photo")
        let secondOptionTitle = "CHOOSE_FROM_LIBRARY".localized(comment: "Choose from Library")
        let alert = UIAlertController.doubleButtonActionSheet(buttonOneTitle: firstOptionTitle,
                                                              buttonTwoTitle: secondOptionTitle,
                                                              actionOne: openCamera,
                                                              actionTwo: openLibrary,
                                                              cancelButtonTitle: "Cancel")
        present(alert, animated: true, completion: nil)
    }
    
    /// Presents a list of actions for an address string.
    ///
    /// - Parameter addressString: Address string.
    func presentAddressActionSheet(addressString: String) {
        let appleMapsAction = UIAlertAction(title: ActionSheetLocalization.openAppleMaps, style: .default) { (_) in
            if let url = ExternalURLConstants.appleMaps(searchTerm: addressString) {
                UIApplication.shared.open(url: url)
            }
        }
        let googleMapsAction = UIAlertAction(title: ActionSheetLocalization.openGoogleMaps, style: .default) { (_) in
            if let url = ExternalURLConstants.googleMaps(searchTerm: addressString) {
                UIApplication.shared.open(url: url)
            }
        }
        let copyAction = UIAlertAction(title: ActionSheetLocalization.copyToClipboard, style: .default) { (_) in
            UIPasteboard.general.string = addressString
        }
        let cancelAction = UIAlertAction(title: ActionSheetLocalization.cancel, style: .cancel, handler: nil)
        let actions = [appleMapsAction, googleMapsAction, copyAction, cancelAction]
        presentActionSheetUsing(alertActions: actions)
    }
    
    /// Email UIAlert Actions
    func presentEmailActionSheet(address: String,
                                 subject: String? = nil) {
        var emailCollectionActions: [UIAlertAction] = []
        
        if let openInGmailURL = ExternalURLConstants.gmail(address: address, subject: subject) {
            let gmailAlertAction = UIAlertAction(title: ActionSheetLocalization.openInGmail, style: .default) { (_) in
                UIApplication.shared.open(url: openInGmailURL)
            }
            emailCollectionActions.append(gmailAlertAction)
        }
        
        if let openEmailURL = URL(email: address) {
            let emailAlertAction = UIAlertAction(title: ActionSheetLocalization.openInMailApp, style: .default) { (_) in
                UIApplication.shared.open(url: openEmailURL)
            }
            emailCollectionActions.append(emailAlertAction)
        }
        
        let copyEmailAlertAction = UIAlertAction(title: ActionSheetLocalization.copyToClipboard, style: .default) { (_) in
            UIPasteboard.general.string = address
        }
        
        emailCollectionActions.append(copyEmailAlertAction)
        
        let cancelAction = UIAlertAction(title: ActionSheetLocalization.cancel, style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        emailCollectionActions.append(cancelAction)
        presentActionSheetUsing(alertActions: emailCollectionActions)
    }
    
    private func presentActionSheetUsing(alertActions: [UIAlertAction]) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertActions.forEach { actionSheet.addAction($0) }
        
        present(actionSheet, animated: true, completion: nil)
    }

}

// MARK: - ErrorDelegate
extension UIViewController: ErrorDelegate {
    
    func displayError(_ error: Error?) {
        presentAlertController(withNetworkError: error)
    }
    
}

// MARK: - KeyboardObserver
extension UIViewController: KeyboardObserver {
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dismissKeyboard),
                                               name: .UIApplicationWillResignActive,
                                               object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillResignActive, object: nil)
    }
    
}
