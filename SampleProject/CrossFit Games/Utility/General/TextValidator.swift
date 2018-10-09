//
//  TextValidator.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/28/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// This file will include general text validations
struct TextValidator {

    // MARK: - Public Functions
    
    /// Validates if a provided email addess is in correct format
    ///
    /// - Parameter email: email text to be validated
    /// - Returns: valid status (true/false)
    static func validate(byEmail email: String) -> Bool {
    
    // MARK: - Public Properties
    
        let emailRegEx = "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" +
                            "\\@" +
                            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                            "(" +
                            "\\." +
                            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                            ")+"

        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
