//
//  EditProfileInformationFormViewDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 4/10/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EditProfileInformationFormViewDelegate: class {
    
    /// Called when an update was made to the neighborhood field.
    ///
    /// - Parameter neighborhood: Neighborhood.
    func neighborhoodUpdated(_ neighborhood: String?)
    
    /// Called when an update was made to the email field.
    ///
    /// - Parameter email: Neighborhood.
    func emailUpdated(_ email: String?)
    
}
