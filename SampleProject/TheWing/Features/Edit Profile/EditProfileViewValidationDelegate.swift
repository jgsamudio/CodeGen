//
//  EditProfileViewValidationDelegate.swift
//  TheWing
//
//  Created by Luna An on 4/3/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EditProfileViewValidationDelegate: class {
    
    /// Indicates if first name field is valid.
    ///
    /// - Parameter valid: Valid.
    func firstNameValidityChanged(valid: Bool)
    
    /// Indicates if last name field is valid.
    ///
    /// - Parameter valid: Valid.
    func lastNameValidityChanged(valid: Bool)
    
    /// Indicates whether biography entry is valid.
    ///
    /// - Parameter valid: Valid
    func biographyValidityChanged(valid: Bool)
    
    /// Indicates whether email entry is valid.
    ///
    /// - Parameter valid: Valid.
    func emailValidityChanged(valid: Bool)
    
    /// Indicates whether occupation field is valid.
    ///
    /// - Parameter valid: Valid.
    func occupationValidityChanged(valid: Bool)
    
    /// Indicates that the validty of the social link changed.
    ///
    /// - Parameters:
    ///   - valid: Boolean indicator of whether social link is valid.
    ///   - socialType: Social link type.
    func socialLinkValidityChanged(valid: Bool, socialType: SocialType)
    
}
