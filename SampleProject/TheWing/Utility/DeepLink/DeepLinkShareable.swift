//
//  DeepLinkShareable.swift
//  TheWing
//
//  Created by Luna An on 5/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol DeepLinkShareable {
    
    /// Title.
    var title: String { get }
    
    /// A unique ID that helps identify the shared object.
    var objectId: String { get }
    
    /// Additional information to add as meta data.
    var additionalInformation: [String: String] { get }
    
    /// Canonical URL.
    var canonicalUrl: String { get }
    
    /// Description for the shared object.
    var contentDescription: String { get }
    
    /// Fallback URL string in case deep link fails to open a specific page on other platforms.
    var fallbackURLString: String { get }
    
}
