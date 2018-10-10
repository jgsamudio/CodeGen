//
//  SFSafariBuilder.swift
//  CrossFit Games
//
//  Created by Satinder Singh on 12/8/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit
import SafariServices

/// Builds SFSafariViewController
struct SFSafariBuilder: Builder {

    // MARK: - Public Properties
    
    /// URL to utilize in web request
    let url: URL

    // MARK: - Public Functions
    
    func build() -> UIViewController {
        let safariViewController = SFSafariViewController(url: url)
        return safariViewController
    }

}
