//
//  GuestFormViewDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

protocol GuestFormViewDelegate: class {

    /// Notifies delegate that given field did end editing.
    ///
    /// - Parameters:
    ///   - formView: Guest form view.
    ///   - row: Guest form row.
    func fieldDidEndEditing(_ formView: GuestFormView, at row: GuestFormRow)
    
    /// Notifies delegate that given field did change.
    ///
    /// - Parameters:
    ///   - formView: Guest form view.
    ///   - row: Guest form row.
    func fieldEditingDidChange(_ formView: GuestFormView, at row: GuestFormRow)
    
}
