//
//  OnboardingSocialEditorViewDelegate.swift
//  TheWing
//
//  Created by Paul Jones on 7/19/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol OnboardingSocialEditorViewDelegate: class {
    
    /// Display the links in the UI, they've been updated.
    ///
    /// - Parameters:
    ///   - website: ex. pljns.com
    ///   - instagram: an Instagram handle
    ///   - facebook: a Facebook handle
    ///   - twitter: a Twitter handle
    func displaySocialLinksView(website: String?, instagram: String?, facebook: String?, twitter: String?)
    
    /// We've started upload, and now it's done. Time to update the UI.
    ///
    /// - Parameters:
    ///   - success: Was the upload successfull?
    ///   - error: Does the upload have an error?
    func uploadCompleted(wasSuccessful success: Bool, withError error: Error?)
    
    /// Notifies delegate that it should display the loading state.
    ///
    /// - Parameter loading: True, should display, false otherwise.
    func isLoading(_ loading: Bool)
    
    /// Indicates that the validty of the social link changed.
    ///
    /// - Parameters:
    ///   - valid: Boolean indicator of whether social link is valid.
    ///   - socialType: Social link type.
    func socialLinkValidityChanged(valid: Bool, socialType: SocialType)
    
    /// Notifies the delegate that the save UI should be enabled or not.
    ///
    /// - Parameter enabled: True, if enabled, false otherwise.
    func setSaveEnabled(_ enabled: Bool)
    
    /// Notifies the delegate that the save UI should be visible or not.
    ///
    /// - Parameter showing: True, if showing, false otherwise.
    func setSaveShowing(_ showing: Bool)
    
}
