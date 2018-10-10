//
//  SocialType.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/29/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Type of social account.
///
/// - Web: Web
/// - Facebook: Facebook.
/// - Instagram: Instagram.
/// - Twitter: Twitter.
enum SocialType: String {
    case web
    case facebook
    case instagram
    case twitter
    
    // MARK: - Public Properties
    
    /// Boolean indicator if social link associated with type is a universal link.
    var universalLinkAvailable: Bool {
        return self != .web
    }
    
    /// Localized invalid input error associated with social account.
    var localizedError: String {
        switch self {
        case .web:
            return "EDIT_SOCIAL_INVALID_URL".localized(comment: "Invalid website url.")
        case .twitter, .instagram:
            return "EDIT_SOCIAL_INVALID_HANDLE".localized(comment: "Invalid handle error message.")
        case .facebook:
            return "EDIT_SOCIAL_INVALID_PROFILE".localized(comment: "Invalid social profile error message.")
        }
    }
    
    // MARK: - Public Functions
    
    /// Returns image icon associated with social type.
    ///
    /// - Returns: Image.
    func image() -> UIImage {
        switch self {
        case .web:
            return #imageLiteral(resourceName: "web_icon")
        case .facebook:
            return #imageLiteral(resourceName: "facebook_icon")
        case .instagram:
            return #imageLiteral(resourceName: "instagram_icon")
        case .twitter:
            return #imageLiteral(resourceName: "twitter_icon")
        }
    }

}
