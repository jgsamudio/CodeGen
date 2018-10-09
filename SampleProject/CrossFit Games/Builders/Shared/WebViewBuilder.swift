//
//  WebViewBuilder.swift
//  CrossFit Games
//
//  Created by Malinka S on 11/1/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Builds Web View Controller
struct WebViewBuilder: Builder {

    private let request: URLRequest

    /// Navigation Title
    let navigationTitle: String?

    let delegate: WebViewControllerDelegate?

    /// Initalizer
    ///
    /// - Parameters:
    ///   - ur: URL to display
    ///   - navigationTitle: String to display on navigation title
    init(url: URL, navigationTitle: String? = nil, delegate: WebViewControllerDelegate? = nil) {
        self.request = URLRequest(url: url)
        self.navigationTitle = navigationTitle
        self.delegate = delegate
    }

    init(urlRequest: URLRequest, navigationTitle: String? = nil, delegate: WebViewControllerDelegate? = nil) {
        self.request = urlRequest
        self.navigationTitle = navigationTitle
        self.delegate = delegate
    }

    func build() -> UIViewController {
        let storyboard = UIStoryboard(name: "Shared", bundle: nil)
        let viewController: WebViewController = storyboard.instantiateViewController()
        viewController.loadURLRequest = request
        viewController.navigationTitle = navigationTitle
        viewController.delegate = delegate
        return viewController
    }
}
