//
//  SubmitScoreService.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/29/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Service for presenting score submission flows.
struct SubmitScoreService {

    let sessionService: SessionService

    private static let submitScoreDelegate = SubmitScoreWebViewDelegate()

    /// Refreshes the user's access token if required and if their user credentials were saved.
    ///
    /// - Parameters:
    ///   - completion: Completion block that is called when the access token refresh has completed. Called with true
    ///     if the refresh was successful or not needed and false if refresh wasn't possible due to not saved credentials.
    ///     If the refresh failed with any error, that error is passed back as well.
    func refreshAccessTokenIfPossible(completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)

        // TODO: We don't need a refresh right now, since we are not sending auth credentials to the web view. Just return true.
        /*
        // No refresh needed. User is logged in and has an active access token.
        if sessionService.isLoggedIn && sessionService.isSessionActive {
            completion(true, nil)
            return
        }

        // No refresh possible. User is not logged in and needs to log in.
        if !sessionService.isLoggedIn {
            completion(false, nil)
            return
        }

        guard let email = sessionService.keychainDataStore.value(for: .username),
            let password = sessionService.keychainDataStore.value(for: .password) else {
                completion(false, nil)
                return
        }

        sessionService.refreshSessionIfNeeded(email: email, password: password) { (error) in
            completion(true, error)
        }
         */
    }

    /// Presents a score submission flow in the given view controller's navigation hierarchy.
    /// If the user is not logged in, this will present a login view controller, if the user is logged in,
    /// it will guide the user directly to the score submission view.
    ///
    /// - Parameter viewController: View controller whose navigation hierarchy will be populated with
    ///   the score submission flow.
    func presentScoreSubmission(in viewController: UIViewController) {
        showSubmitScore(in: viewController, removingTopViewController: false)

        // TODO: We don't need to be logged in to show score submission right now.
        /**
        guard sessionService.isLoggedIn && sessionService.isSessionActive else {
            let completion: (LoginEvent) -> Void = { result in
                switch result {
                case .loginCancelled:
                    break
                case .loginSucceeded:
                    self.showSubmitScore(in: viewController, removingTopViewController: true)
                }
            }

            let loginViewController = LoginBuilder(loginCompletion: completion).build()
            viewController.navigationController?.pushViewController(loginViewController, animated: true)
            return
        }
         */

        showSubmitScore(in: viewController, removingTopViewController: false)
    }

    private func showSubmitScore(in viewController: UIViewController, removingTopViewController: Bool) {
        var urlComponents = URLComponents(url: CFEnvironmentManager.shared.currentGeneralEnvironment.baseURL
            .appendingPathComponent("submit-scores"), resolvingAgainstBaseURL: false)
        //urlComponents?.queryItems = [URLQueryItem.init(name: "mobile-app-client", value: "1")]
        do {
            guard let url = try urlComponents?.asURL() else {
                return
            }

            let safariViewController = SFSafariBuilder(url: url).build()
            safariViewController.modalPresentationStyle = .overFullScreen
            viewController.present(safariViewController, animated: true, completion: nil)
        } catch {
            return
        }
        // TODO: Ideally we want this to stick around, unfortunately there's an issue in that implementation.
        /**
        do {
            guard let url = try urlComponents?.asURL() else {
                return
            }
            let token = (UserDefaultsManager.shared.getValue(byKey: UserDefaultsKey.userAccessToken) as? String) ?? ""
            let urlRequest = try URLRequest(url: url,
                                            method: .get,
                                            headers: [
                                                "Authorization":
                                                "Bearer \(token)"
                ])
            if let navigationController = viewController.navigationController {
                let webViewController = WebViewBuilder(urlRequest: urlRequest,
                                                       delegate: SubmitScoreService.submitScoreDelegate).build()
                if #available(iOS 11.0, *) {
                    webViewController.navigationItem.largeTitleDisplayMode = .never
                }
                var currentNavStack = Array(navigationController.viewControllers.dropLast())
                currentNavStack.append(webViewController)
                UIView.animate(withDuration: 0.3, animations: {
                    navigationController.pushViewController(webViewController, animated: true)
                }, completion: { _ in
                    if removingTopViewController {
                        navigationController.setViewControllers(currentNavStack, animated: false)
                    }
                })
            }
        } catch {
            return
        }
         */
    }

}
