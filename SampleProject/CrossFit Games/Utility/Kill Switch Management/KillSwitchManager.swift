//
//  KillSwitchManager.swift
//  CrossFit Games
//
//  Created by Malinka S on 1/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Alamofire
import UIKit

/// Manages validations required to perform kill switch
struct KillSwitchManager {

    /// Validates the API status
    /// Iterates through the given headers and checks for API status updates
    ///
    /// - Parameter headers: Response headers
    /// - Returns: force update status, api inactive status
    static func validateApiStatus(with headers: [String: Any]) -> APIError? {
        #if ALPHA || BETA || DEBUG
            if let useDummy = UserDefaultsManager.shared.getValue(byKey: .useDummyForKillSwitch) as? Bool, useDummy {
                return produceDummyData()
            }

        #endif
        return headers.flatMap({ (element) in
            let decoder = JSONDecoder()
            if element.key == "CrossFit-API-Status" {
                do {
                    if let jsontString = element.value as? String, let data = jsontString.data(using: String.Encoding.utf8) {
                        return try decoder.decode(APIError.self, from: data)
                    } else {
                        return nil
                    }
                } catch {
                    print(error)
                    return nil
                }
            } else {
                return nil
            }
        }).first
    }

    static func isAppRequiredForceUpdate(with version: String) -> Bool {
        // check current app version
        if let infoDict = Bundle.main.infoDictionary,
            let appVersion = infoDict["CFBundleShortVersionString"] as? String {
            if String.compareVersions(version1: appVersion, version2: version) == .orderedAscending {
                return true
            }
        }
        #if ALPHA || BETA || DEBUG
            if let useDummy = UserDefaultsManager.shared.getValue(byKey: .useDummyForKillSwitch) as? Bool, useDummy {
                if let forceUpdateStatus = UserDefaultsManager.shared.getValue(byKey: .forceAppUpdate) as? Bool,
                    forceUpdateStatus {
                    return forceUpdateStatus
                }
            }
        #endif
        return false
    }

    /// Checks if we need a status API check.
    ///
    /// - Parameters:
    ///   - code: Status code.
    ///   - isAuthRequest: Specifies if it's an auth request.
    /// - Returns: True if a status check is needed.
    static func needsAPIStatusCheck(code: Int, isAuthRequest: Bool = false) -> Bool {
        if isAuthRequest {
            return code == 400 || code > 401
        }
        return code >= 400
    }

    /// Checks the API status
    ///
    /// - Parameters:
    ///   - completion: completion block with the error
    static func checkAPIStatus(completion: @escaping (Error?) -> Void) {
        #if ALPHA || BETA || DEBUG
            if let useDummy = UserDefaultsManager.shared.getValue(byKey: .useDummyForKillSwitch) as? Bool, useDummy {
                completion(produceDummyData())
                return
            }
        #endif

        let requestURL = CFEnvironmentManager.shared.currentGeneralEnvironment.baseURL
            .appendingPathComponent("status")
        Alamofire.request(requestURL).responseJSON(completionHandler: { (response) in

            guard let data = response.data else {
                completion(response.error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let apiError = try decoder.decode(APIError.self, from: data)
                completion(apiError)
            } catch {
                completion(response.error)
            }
        })
    }

    /// Check API status when the app becomes active
    ///
    /// - Parameters:
    ///   - isRetryAttempt: For retrying attempts
    ///   - completion: completion block
    static func checkApiStatusOnAppBecomingActive(isRetryAttempt: Bool = false, completion: @escaping (Error?) -> Void = { _ in }) {
        KillSwitchManager.checkAPIStatus(completion: { error in
            if let error = error {
                switch error {
                case APIError.inactive(title: let title, message: let message):
                    FullscreenErrorView.presentWindow(title: title, message: message, onTap: { isRetrying in
                        checkApiStatusOnAppBecomingActive(isRetryAttempt: true, completion: isRetrying)
                    })
                case APIError.forceUpdate(title: let title, message: let message, storeLink: let storeLink):
                    KillSwitchManager.showForceUpdateAlert(title: title, message: message, storeLink: storeLink)
                default:
                    break
                }
            } else {
                KillSwitchManager.hideWindow()
            }
        })
    }

    private static weak var alertViewController: UIAlertController?

    /// Shows the alert window for force update
    ///
    /// - Parameters:
    ///   - title: Title to be displayed
    ///   - message: message to be displayed
    ///   - storeLink: App store URL
    static func showForceUpdateAlert(title: String, message: String, storeLink: String) {
        guard alertViewController == nil else {
            return
        }
        DispatchQueue.main.async {
            let localization = GeneralLocalization()
            let presentingViewController = UIViewController()
            presentingViewController.view.backgroundColor = .clear

            let alert = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
            if let appStoreURL = URL(string: storeLink) {
                alert.addAction(UIAlertAction(title: localization.forceUpdate,
                                                            style: .default,
                                                            handler: { _ in
                                                                UIApplication.shared.open(appStoreURL, options: [:],
                                                                                          completionHandler: nil)

                }))
            }

            let appWindow = UIApplication.shared.keyWindow
            appWindow?.addSubview(presentingViewController.view)
            presentingViewController.present(alert, animated: true, completion: nil)
            alertViewController = alert
        }

    }

    /// Hides the kill switch window if it's the current key window
    static func hideWindow() {
        if let keyWindow = UIApplication.shared.keyWindow as? KillSwitchWindow {
            keyWindow.isHidden = true
        }
    }

    private static func produceDummyData() -> APIError? {
        if let forceUpdateStatus = UserDefaultsManager.shared.getValue(byKey: .forceAppUpdate) as? Bool,
            forceUpdateStatus {
            return APIError.forceUpdate(
                title: "Update Available",
                message: "Download latest app \nfrom the app store",
                storeLink: "https://itunes.apple.com/us/app/2017-reebok-crossfit-games/id1240868782?mt=8")
        } else if let killSwitchStatus = UserDefaultsManager.shared.getValue(byKey: .killSwitchStatus) as? Bool, killSwitchStatus {
            return APIError.inactive(title: "App unavailable", message: "Please try again later")
        }
        return nil
    }

}
