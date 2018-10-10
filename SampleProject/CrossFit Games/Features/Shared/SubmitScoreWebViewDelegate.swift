//
//  SubmitScoreWebViewDelegate.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 2/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import WebKit

/// Delegate for a submit score screen to log when users got redirected
final class SubmitScoreWebViewDelegate: NSObject, WebViewControllerDelegate {

    // MARK: - Private Properties
    
    private let redirectIndication = "/cf/login"

    // MARK: - Public Functions
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.url?.absoluteString.contains(redirectIndication) == true {
            CrashlyticsIntegration.shared.log(event: .submitScoreRedirectToLogin)
        }
    }

}
