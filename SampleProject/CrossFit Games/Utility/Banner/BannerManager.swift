//
//  BannerManager.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/4/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit
import NotificationBannerSwift

/// Manages banner operations
struct BannerManager {

    // MARK: - Public Functions
    
    /// Shows banner on the main window
    ///
    /// - Parameters:
    ///   - text: title to be displayed in the banner
    static func showBanner<T>(text: String, onTap: @escaping () -> Void = {}, delegate: T? = nil,
                              duration: TimeInterval = 5) where T: NSObject {
        if let customView = GeneralErrorBannerView.fromNib() {
            customView.setTitle(title: text)
    
    // MARK: - Public Properties
    
            let banner = NotificationBanner(customView: customView)
            banner.onTap = onTap
            banner.duration = duration
            banner.bannerHeight = 114
            banner.layer.shadowColor = UIColor.black.cgColor
            banner.layer.shadowOffset = .init(width: 0, height: 1)
            banner.layer.shadowRadius = 3
            banner.layer.shadowOpacity = 0.8
            banner.clipsToBounds = true
            if let delegate = delegate as? NotificationBannerDelegate {
                banner.delegate = delegate
            }
            banner.show(queuePosition: .front, bannerPosition: .top)
        }
    }

    static func showError(onTap: @escaping () -> Void = {}) {
        let generalLocalization = GeneralLocalization()
        let bannerText = generalLocalization.bannerErrorTitle
        BannerManager.showBanner(text: bannerText, onTap: onTap, delegate: nil)
    }
}
