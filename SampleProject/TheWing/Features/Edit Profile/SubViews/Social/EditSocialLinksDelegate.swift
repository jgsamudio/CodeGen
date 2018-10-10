//
//  EditSocialLinksDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EditSocialLinksDelegate: class {

    /// Called when link is updated.
    ///
    /// - Parameter link: Facebook link.
    func facebookUpdated(username: String?)

    /// Called when link is updated.
    ///
    /// - Parameter link: Instagram link.
    func instagramUpdated(username: String?)

    /// Called when link is updated.
    ///
    /// - Parameter link: Twitter link.
    func twitterUpdated(username: String?)

    /// Called when link is updated.
    ///
    /// - Parameter link: Website link.
    func websiteUpdated(link: String?)
    
}
