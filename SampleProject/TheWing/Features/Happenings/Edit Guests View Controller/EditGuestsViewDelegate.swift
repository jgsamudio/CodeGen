//
//  EditGuestsViewDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

protocol EditGuestsViewDelegate: ErrorDelegate {

    /// Sets whether adding more guests is enabled.
    ///
    /// - Parameter enabled: True, if can add more guests, false otherwise.
    func setAddEnabled(_ enabled: Bool)
    
    /// Appends guest.
    func appendGuestForm()
    
    /// Appends deletable guest information.
    ///
    /// - Parameters:
    ///   - name: Guest name.
    ///   - email: Guest email.
    func appendDeletableGuest(name: String, email: String)
    
    /// Display additional information given message.
    ///
    /// - Parameter message: Message.
    func displayInfo(message: String)
    
    /// Shows error in field at given section and row with given message.
    ///
    /// - Parameters:
    ///   - section: Section key of form.
    ///   - row: Row key of form field.
    ///   - message: Error message.
    func showError(in section: Int, at row: GuestFormRow, message: String)
    
    /// Hides error in field at given section and row.
    ///
    /// - Parameters:
    ///   - section: Section key of form.
    ///   - row: Row key of form field.
    func hideError(in section: Int, at row: GuestFormRow)

    /// Sets whether the save action is enabled or disabled.
    ///
    /// - Parameter enabled: True, if should be enabled, false otherwise.
    func setSaveEnabled(_ enabled: Bool)
    
    /// Dismiss action.
    func dismissAction()
    
    /// Notifies delegate that an attempt was made to discard changes.
    func discardAttempt()
    
}
