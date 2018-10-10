//
//  EditHeaderInfoViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 4/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EditHeaderInfoViewDelegate: class {
    
    /// Indicates the first name is updated with the user entered input.
    ///
    /// - Parameter name: User entered name.
    func firstNameUpdated(with name: String?)
    
    /// Indicates the last name is updated with the user entered input.
    ///
    /// - Parameter name: User entered name.
    func lastNameUpdated(with name: String?)
    
    /// Indicates that the headline is updated with user input.
    ///
    /// - Parameter text: User inputed headline.
    func headlineUpdated(with text: String?)
    
}
