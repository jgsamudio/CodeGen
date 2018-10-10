//
//  BuildableViewController.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit
import UserNotifications
import Velar

/// Base view controller for the main views of the application.
class BuildableViewController: UIViewController, Buildable {
    
    // MARK: - Public Properties

    let builder: Builder
    
    let theme: Theme
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return snackBarView.displayed ? .lightContent : super.preferredStatusBarStyle
    }
    
    // MARK: - Private Properties

    private lazy var snackBarView: SnackBarView = {
        let view = SnackBarView(message: "", theme: theme)
        view.delegate = self
        return view
    }()
    
	// MARK: - Initialization

    // MARK: - Initialization
    
    init(builder: Builder, theme: Theme) {
        self.builder = builder
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Public Functions

    /// Checks if is registered and can attempt
    func presentPushPermissionAlertIfNeeded() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] (settings) in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    if UserDefaults.standard.canAttemptToAskForPushPermission {
                        self?.presentPushPermissionAlert()
                    }
                default:
                    return
                }
            }
        }
    }
    
    /// Just pushes, use the ifNeeded version for production work.
    private func presentPushPermissionAlert() {
        let presenter = VelarPresenterBuilder.build(designer: DefaultBackgroundOverlayDesigner(theme: builder.theme))
        let modal = PushNotificationPromptView(theme: builder.theme)
        modal.presenter = presenter
        modal.delegate = self
        presenter.show(view: modal, animate: true)
        UserDefaults.standard.pushPermissionLastAskedDate = Date()
    }

    func showSnackBar(with message: Localizable, dismissAfter: TimeInterval? = nil, animated: Bool = true) {
        snackBarView.message = message.localized
        snackBarView.show(animated: animated)
        
        if let dismissAfter = dismissAfter {
            DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.snackBarView.dismiss(animated: animated)
            }
        }
    }

    func hideSnackBar(animated: Bool = true) {
        snackBarView.dismiss(animated: animated)
    }

}

// MARK: - PushNotificationPromptViewDelegate
extension BuildableViewController: PushNotificationPromptViewDelegate {
    
    func pushNotificationPromptViewDidConfirm(_ view: PushNotificationPromptView) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { [weak self] (granted, _) in
            DispatchQueue.main.async {
                guard granted else {
                    return
                }
                
                UIApplication.shared.registerForRemoteNotifications()
                UserDefaults.standard.pushHappenings = true
                UserDefaults.standard.pushAnnoucements = true
                if let user = self?.sessionManager.user {
                    self?.analyticsProvider.identify(userId: user.userId, userTraits: UserAttributesData.shared.userTraits)
                }
            }
        }
    }
    
}

// MARK: - CalendarPermissionsValidatorDelegate
extension BuildableViewController: CalendarPermissionsValidatorDelegate {
    
    func requestingCalendarPermission() {
        showSnackBar(with: SnackBarLocalization.calenderPermission)
    }
    
    func calendarEventAdded(eventInfo: EventCalendarInfo) {
        let message = "\(eventInfo.title)\("HAPPENING_ADDED_MESSAGE".localized(comment: "Happening added message"))"
        let title = "HAPPENING_ADDED_TITLE".localized(comment: "Happening Added")
        let alert = UIAlertController.singleActionAlertController(title: title, message: message)
        alert.present()
        hideSnackBar()
    }
    
    func calendarPermissionsDenied() {
        let title = "CALENDAR_ACCESS_TITLE".localized(comment: "Calendar Access Title")
        let message = "CALENDAR_ACCESS_MESSAGE".localized(comment: "Calendar Access Message")
        let cancel = "CANCEL_TITLE".localized(comment: "Cancel")
        let settings = "SETTINGS".localized(comment: "Settings")
        let alert = UIAlertController.doubleActionAlertController(title: title,
                                                                  message: message,
                                                                  actionOneTitle: cancel,
                                                                  actionTwoTitle: settings,
                                                                  actionOne: nil) {
                                                                    UIApplication.shared.openSettings()
        }
        alert.present()
        hideSnackBar()
    }
    
}

// MARK: - SnackBarDelegate
extension BuildableViewController: SnackBarDelegate {
    
    func updateStatusBar() {
        setNeedsStatusBarAppearanceUpdate()
    }
    
}

