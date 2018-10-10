//
//  EventGuestRegistrationData.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

struct EventGuestRegistrationData: Equatable {
    
    // MARK: - Public Properties
    
    /// Guest first name.
    var firstName = ""
    
    /// Guest last name.
    var lastName = ""
    
    /// Guest email.
    var email = ""
    
    /// Predicate determining if whole data collection is valid.
    var valid: Bool {
        return isEmpty || (validFirstName && validLastName && validEmail)
    }
    
    /// Predicate determining if data is empty.
    var isEmpty: Bool {
        return firstName.isEmpty && lastName.isEmpty && email.isEmpty
    }
    
    /// Predicate determining if first name is valid.
    var validFirstName: Bool {
        return firstName.isValidString
    }
    
    /// Predicate determining if last name is valid.
    var validLastName: Bool {
        return lastName.isValidString
    }
    
    /// Predicate determining if email address is valid.
    var validEmail: Bool {
        return email.isValidEmail
    }
    
    /// JSON request body representation of object.
    var parameters: [String: String] {
        var params = [String: String]()
        params["firstName"] = firstName
        params["lastName"] = lastName
        params["email"] = email
        return params
    }
    
}
