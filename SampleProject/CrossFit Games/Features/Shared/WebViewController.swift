//
//  WorkoutPDFViewController.swift
//  CrossFit Games
//
//  Created by Malinka S on 11/1/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit
import WebKit

private struct Constants {

    // MARK: - Public Properties
    
    /// Setup web view to load request and ensure content will always fit device width.
    /// Script enforcing size discovered in following note
    /// - NOTE: http://stackoverflow.com/questions/26295277/wkwebview-equivalent-for-uiwebviews-scalespagetofit
    static var fitScreenWidth: String {
        return "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport');" +
        "meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
    }

    /// Disables user callout.
    static var disableUserCallout: String {
        return "document.documentElement.style.webkitTouchCallout='none'"
    }

}

/// Display web views within view controller
final class WebViewController: BaseViewController {

    // MARK: - Private Properties
    
    private var webView: WKWebView!
    private var originalBackgroundColor: UIColor!

    var loadURLRequest: URLRequest?

    /// Navigation title to display
    var navigationTitle: String?

    /// Delegate that is notified about web view interaction.
    weak var delegate: WebViewControllerDelegate?

    // MARK: - Public Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = navigationTitle?.capitalized
        setupWebView()
        loadWebView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        originalBackgroundColor = navigationController?.navigationBar.backgroundColor
        navigationController?.navigationBar.backgroundColor = .white
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.backgroundColor = originalBackgroundColor
    }

    /// Setup web view to load request and ensure content will always fit device width.
    /// Script enforcing size discovered in following note
    /// - NOTE: http://stackoverflow.com/questions/26295277/wkwebview-equivalent-for-uiwebviews-scalespagetofit
    private func setupWebView() {
        let fitScreenWidth = Constants.fitScreenWidth
        let wkUScript = WKUserScript(source: fitScreenWidth, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(wkUScript)
        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController
        webView = WKWebView(frame: view.frame, configuration: wkWebConfig)
        webView.navigationDelegate = self
        webView.alpha = 0
        view.addSubview(webView)
        webView.pinToSuperview(top: 0, leading: 0, bottom: 0, trailing: 0)
        view.backgroundColor = .white
    }

    private func loadWebView() {
        startActivityIndicator()
        if let loadURLRequest = loadURLRequest {
            webView.load(loadURLRequest)
        }
    }

}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate?.webView?(webView, didFinish: navigation)
        // Disable callout (default behavior of long press gesture triggers callout view to show)
        webView.evaluateJavaScript(Constants.disableUserCallout, completionHandler: nil)
        // Delaying display of webview because it is unresponsive to user touch when initially loaded.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.stopActivityIndicator()
            UIView.animate(withDuration: 0.5, animations: {
                self.webView?.alpha = 1
            }, completion: { _ in
                self.webView?.setNeedsLayout()
            })
        }
    }

}
