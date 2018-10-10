//
//  FormField.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/10/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol FormField {

    /// The form delegate.
    var formDelegate: FormDelegate? { get set }

    /// Called to resign the first responser.
    func resignFirstResponder()
    
}
