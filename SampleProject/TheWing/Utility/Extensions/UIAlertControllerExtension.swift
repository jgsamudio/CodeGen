//
//  UIAlertControllerExtension.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/26/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

extension UIAlertController {

    // MARK: - Public Functions
    
    /// Creates an alert view controller with a single confirmation button.
    ///
    /// - Parameters:
    ///   - title: Title of the controller.
    ///   - message: Message of the controller.
    /// - Returns: Configured UIAlertController.
    static func singleActionAlertController(title: String, message: String) -> UIAlertController {
    
    // MARK: - Public Properties
    
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ALERT_CONFIRMATION_TITLE".localized(comment: "Ok"),
                                      style: .cancel,
                                      handler: nil))
        return alert
    }
    
    /// Creates an alert view controller with a destructive action.
    ///
    /// - Parameters:
    ///   - title: Optional title of controller.
    ///   - message: Optional message of controller.
    ///   - deleteTitle: Title of destructive button.
    ///   - handler: Handler.
    /// - Returns: Configured UIAlertController.
    static func deleteActionAlertController(title: String? = nil,
                                            message: String? = nil,
                                            deleteTitle: String?,
                                            handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL_TITLE".localized(comment: "Cancel"),
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: deleteTitle, style: .destructive, handler: handler))
        return alert
    }
    
    // MARK: - Initialization
    
    /// Builds a UIAlertController with a network error, to be shown when things go wrong, as they inevitably sometimes do.
    ///
    /// - Parameter error: the error that you received from the network.
    convenience init(withNetworkError error: Error?) {
        var message = ErrorLocalization.networkErrorBodyText
        if let error = error as? APIError, error.isBackendError {
            message = error.localizedDescription
        }
        self.init(title: ErrorLocalization.networkErrorTitleText, message: message, preferredStyle: .alert)
        addAction(UIAlertAction(title: ErrorLocalization.networkErrorActionText, style: .default, handler: nil))
    }
    
    /// Creates an alert view controller with dobule confirmation buttons.
    ///
    /// - Parameters:
    ///   - title: Title of the controller.
    ///   - message: Message of the controller.
    ///   - actionOneTitle: Alert action one title.
    ///   - actionTwoTitle: Alert action two title.
    ///   - actionOne: Alert action associated with action one button.
    ///   - actionTwo: Alert action associated with action two button.
    /// - Returns: Configured UIAlertController.
    static func doubleActionAlertController(title: String,
                                            message: String,
                                            actionOneTitle: String,
                                            actionTwoTitle: String,
                                            actionOne: (() -> Void)? = nil,
                                            actionTwo: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionOne = UIAlertAction(title: actionOneTitle, style: .cancel) { _ in
            actionOne?()
        }
        
        let actionTwo = UIAlertAction(title: actionTwoTitle, style: .default) { _ in
            actionTwo?()
        }
        
        alert.addAction(actionOne)
        alert.addAction(actionTwo)
        
        return alert
    }

    /// Creates an alert view controller with double confirmation buttons and a cancel button.
    ///
    /// - Parameters:
    ///   - title: Title of the controller.
    ///   - message: Message of the controller.
    ///   - buttonOneTitle: Alert action button one title.
    ///   - buttonTwoTitle:  Alert action button two title.
    ///   - actionButtonStyle: Action button style.
    ///   - actionOne: Alert action associated with action one button.
    ///   - actionTwo: Alert action associated with action two button.
    ///   - cancelButtonTitle: Cancel button title.
    /// - Returns: Configured UIAlertController.
    static func doubleButtonActionSheet(title: String? = nil,
                                        message: String? = nil,
                                        buttonOneTitle: String,
                                        buttonTwoTitle: String,
                                        actionButtonStyle: UIAlertActionStyle = .default,
                                        actionOne: (() -> Void)? = nil,
                                        actionTwo: (() -> Void)? = nil,
                                        cancelButtonTitle: String) -> UIAlertController {
        let dismissAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        
        let alertActionOne = UIAlertAction(title: buttonOneTitle, style: actionButtonStyle) { _ in
            actionOne?()
        }
        
        let alertActionTwo = UIAlertAction(title: buttonTwoTitle, style: actionButtonStyle) { _ in
            actionTwo?()
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        alert.addAction(dismissAction)
        alert.addAction(alertActionOne)
        alert.addAction(alertActionTwo)

        return alert
    }
    
    /// Presents the alert view controller on top of all other views.
    func present() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        window.rootViewController = viewController
        window.windowLevel = UIWindowLevelAlert + 1
        window.makeKeyAndVisible()
        viewController.present(self, animated: true, completion: nil)
    }

}
