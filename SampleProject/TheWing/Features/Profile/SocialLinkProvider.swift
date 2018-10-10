//
//  SocialLinkProvider.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Social link provider.
protocol SocialLinkProvider {
    
    /// Facebook.
    var facebook: String? { get }
    
    /// Instagram.
    var instagram: String? { get }
    
    /// Twitter.
    var twitter: String? { get }
    
    /// Website.
    var website: String? { get }
    
}

extension SocialLinkProvider {
    
    // MARK: - Public Properties
    
    /// Is it valid?
    /// This is mostly for analytics, but could be useful for other stuff too.
    var socialComplete: Bool {
        return !socialFields.isEmpty
    }
    
    /// Get the set of values of the social fields, prefixed with service name to avoid collision.
    /// This is mostly for analytics.
    var socialValues: Set<String> {
        var set = Set<String>()
        
        if let facebook = facebook?.nilIfEmpty {
            set.insert("\(SocialType.facebook.rawValue):\(facebook)")
        }
        
        if let twitter = twitter?.nilIfEmpty {
            set.insert("\(SocialType.twitter.rawValue):\(twitter)")
        }
        
        if let instagram = instagram?.nilIfEmpty {
            set.insert("\(SocialType.instagram.rawValue):\(instagram)")
        }
        
        if let website = website?.nilIfEmpty {
            set.insert("\(SocialType.web.rawValue):\(website)")
        }
        
        return set
    }
    
    /// Get the social fields that are container in this provider.
    /// This is mostly for analytics.
    var socialFields: Set<SocialType> {
        var set = Set<SocialType>()
        if facebook?.nilIfEmpty != nil {
            set.insert(.facebook)
        }
        
        if twitter?.nilIfEmpty != nil {
            set.insert(.twitter)
        }
        
        if instagram?.nilIfEmpty != nil {
            set.insert(.instagram)
        }
        
        if website?.nilIfEmpty != nil {
            set.insert(.web)
        }
        
        return set
    }
    
}
