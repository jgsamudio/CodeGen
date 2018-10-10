//
//  EditGuestsViewModel.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class EditGuestsViewModel {
    
    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    weak var delegate: EditGuestsViewDelegate?
    
    /// View title.
    var title: String {
        if (oldGuestData.map { $0.isEmpty }).all(true) {
            return "ADD_GUESTS_TITLE".localized(comment: "Add guest")
        } else {
            return "EDIT_GUESTS_TITLE".localized(comment: "Edit guest")
        }
    }
    
    // MARK: - Private Properties
    
    private let event: EventData
    
    private let dependencyProvider: DependencyProvider
    
    private weak var guestsDelegate: GuestsDelegate?
    
    private var eventId: String {
        return event.eventId
    }
    
    private var guestPerMember: Int {
        return event.guestPerMember
    }
    
    private let oldGuestData: [EventGuestRegistrationData]
    
    private var edited: Bool {
        return editableGuestData != oldGuestData
    }
    
    private var isValidUpdate: Bool {
        return editableGuestData.map { $0.valid }.all(true) && !guestEmailsContainDuplicates
    }
    
    private var deletableGuestData = [EventGuestRegistrationData]()
    
    private var editableGuestData = [EventGuestRegistrationData]() {
        didSet {
            saveEnabled = edited
            delegate?.setAddEnabled(editableGuestData.count < guestPerMember)
            if editableGuestData.isEmpty {
                addGuestForm()
            }
        }
    }
    
    private var guestEmailsContainDuplicates: Bool {
        return editableGuestData.map({$0.email}).containsDuplicates
    }
    
    private var saveEnabled = false {
        didSet {
            delegate?.setSaveEnabled(saveEnabled)
        }
    }
    
    // MARK: - Initialization
    
    /// Initializes edit guests view model with event id, count of guests allowed, array of guest data, and dependencies.
    ///
    /// - Parameters:
    ///   - eventId: Event identifier.
    ///   - guestPerMember: Count of guests allowed per member.
    ///   - guestData: Guest data.
    ///   - dependencyProvider: Dependency provider.
    init(event: EventData,
         guestsDelegate: GuestsDelegate?,
         dependencyProvider: DependencyProvider) {
        self.event = event
        oldGuestData = (event.guestsData?.isEmpty ?? true) ? [EventGuestRegistrationData()] : (event.guestsData ?? [])
        self.guestsDelegate = guestsDelegate
        self.dependencyProvider = dependencyProvider
    }
    
    // MARK: - Public Functions
    
    /// Loads guest flow.
    func loadGuestFlow() {
        editableGuestData = oldGuestData.filter { !$0.isEmpty }
        deletableGuestData = oldGuestData.filter { !$0.isEmpty }
        if guestPerMember > 1 {
            let message = "MORE_GUESTS_ALLOWED".localized(comment: "More guests allowed.")
            delegate?.displayInfo(message: String(format: message, "\(guestPerMember)"))
        } else {
            delegate?.displayInfo(message: "ONE_GUEST_ALLOWED".localized(comment: "One guest allowed."))
        }
        configureGuests()
    }
    
    /// Edits guest information with input at given section.
    ///
    /// - Parameters:
    ///   - text: Input string.
    ///   - section: Section key of form.
    ///   - row: Row key of form field.
    func editGuest(with text: String?, in section: Int, at row: GuestFormRow) {
        let index = section + deletableGuestData.count
        switch row {
        case .firstName:
            editableGuestData[index].firstName = text ?? ""
            if isValidGuestName(text) {
                delegate?.hideError(in: section, at: row)
            }
        case .lastName:
            editableGuestData[index].lastName = text ?? ""
            if isValidGuestName(text) {
                delegate?.hideError(in: section, at: row)
            }
        case .email:
            editableGuestData[index].email = text ?? ""
            if isValidEmail(text) {
                delegate?.hideError(in: section, at: row)
            }
        }
    }
    
    /// Validates text in field at given section and row.
    ///
    /// - Parameters:
    ///   - text: Optional text.
    ///   - section: Section key of form.
    ///   - row: Row key of form field.
    func validateFormField(with text: String?, in section: Int, at row: GuestFormRow) {
        switch row {
        case .firstName:
            setValid(isValidGuestName(text),
                     in: section,
                     at: row, message: "FIRST_NAME_GUEST_ERROR".localized(comment: "First name error"))
        case .lastName:
            setValid(isValidGuestName(text),
                     in: section,
                     at: row, message: "LAST_NAME_GUEST_ERROR".localized(comment: "Last name error"))
        case .email:
            if guestEmailsContainDuplicates {
                setValid(false,
                         in: section,
                         at: row,
                         message: "DUPLICATE_EMAIL_ERROR_MESSAGE".localized(comment: "Duplicate email"))
            } else {
                setValid(isValidEmail(text),
                         in: section,
                         at: row,
                         message: "EMAIL_ERROR_MESSAGE".localized(comment: "Email error"))
            }
        }
    }
    
    /// Delete guest action.
    ///
    /// - Parameter section: Section index of guest form.
    func deleteAction(in section: Int) {
        editableGuestData.remove(at: section)
        deletableGuestData.remove(at: section)
    }
    
    /// Cancel edit action.
    @objc func cancelAction() {
        edited ? delegate?.discardAttempt() : delegate?.dismissAction()
    }
    
    /// Save edits action.
    @objc func save() {
        guard isValidUpdate else {
            displayAllErrors()
            return
        }
        
        let newGuestData = editableGuestData.filter { !$0.isEmpty }
        saveEnabled = false
        dependencyProvider.networkProvider.eventsLoader.editGuests(eventId: eventId, guestData: newGuestData) { (result) in
            result.ifSuccess {
                self.guestsDelegate?.updatedGuests(result.value?.data.guests, eventId: self.eventId)
                self.delegate?.dismissAction()
            }
            result.ifFailure {
                self.saveEnabled = true
                self.delegate?.displayError(result.error)
            }
        }
    }
    
    /// Add another guest form action.
    @objc func addGuestForm() {
        delegate?.appendGuestForm()
        editableGuestData.append(EventGuestRegistrationData())
    }
    
}

// MARK: - Private Functions
private extension EditGuestsViewModel {
    
    func configureGuests() {
        deletableGuestData.forEach {
            delegate?.appendDeletableGuest(name: "\($0.firstName) \($0.lastName)", email: $0.email)
        }
    }
    
    func setValid(_ valid: Bool, in section: Int, at row: GuestFormRow, message: String?) {
        if !valid, let message = message {
            delegate?.showError(in: section, at: row, message: message)
        } else {
            delegate?.hideError(in: section, at: row)
        }
    }
    
    func isValidGuestName(_ input: String?) -> Bool {
        guard let name = input else {
            return false
        }
        
        return name.isValidString
    }
    
    func isValidEmail(_ input: String?) -> Bool {
        guard let email = input else {
            return false
        }
        
        return email.isValidEmail
    }

    func displayAllErrors() {
        let formsIndex = deletableGuestData.count
        
        editableGuestData[formsIndex..<editableGuestData.count].forEach {
            let index = editableGuestData.index(of: $0)! - deletableGuestData.count
            if !$0.isEmpty {
                setValid($0.validFirstName,
                         in: index,
                         at: .firstName,
                         message: "FIRST_NAME_GUEST_ERROR".localized(comment: "First name error"))
                setValid($0.validLastName,
                         in: index,
                         at: .lastName,
                         message: "LAST_NAME_GUEST_ERROR".localized(comment: "Last name error"))
                setValid($0.validEmail,
                         in: index,
                         at: .email,
                         message: "EMAIL_ERROR_MESSAGE".localized(comment: "Email error"))
            } else {
                setValid(true, in: index, at: .firstName, message: nil)
                setValid(true, in: index, at: .lastName, message: nil)
                setValid(true, in: index, at: .email, message: nil)
            }
        }
    }
    
}

// MARK: - AnalyticsRepresentable
extension EditGuestsViewModel: AnalyticsRepresentable {
    
    var analyticsProperties: [String: Any] {
        return event.analyticsProperties
    }
    
}
