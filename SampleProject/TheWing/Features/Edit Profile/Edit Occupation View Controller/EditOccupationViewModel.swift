//
//  EditOccupationViewModel.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/2/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class EditOccupationViewModel {

    // MARK: - Public Properties

    /// Binding delegate for the view model.
    weak var delegate: EditOccupationViewDelegate?
    
    let occupation: Occupation?
    
    /// Temporary occupation value used to set the add/edit occupation's text fields.
    var editableOccupation: EditableOccupation? {
        didSet {
            checkValidSave()
        }
    }
    
    var navigationTitle: String {
        return type.title
    }

    // MARK: - Private Properties

    private let dependencyProvider: DependencyProvider
    
    private let type: EditOccupationType
    
    private var canSave: Bool = false {
        didSet {
            delegate?.canSaveOccupation(canSave)
        }
    }

    // MARK: - Initialization

    init(occupation: Occupation?, type: EditOccupationType, dependencyProvider: DependencyProvider) {
        self.occupation = occupation
        self.type = type
        self.dependencyProvider = dependencyProvider
        editableOccupation = EditableOccupation(company: occupation?.company, position: occupation?.position)
    }

    // MARK: - Public Functions

    /// Loads the current occupation.
    func loadOccupation() {
        delegate?.display(position: occupation?.position, company: occupation?.company)
        displayDelete()
    }
    
    @objc func saveOccupation() {
        if let position = editableOccupation?.position {
            delegate?.returnToEditProfile(position: position, company: editableOccupation?.company, deleted: false)
        }
    }
    
    @objc func deleteOccupation() {
        if let position = editableOccupation?.position {
            delegate?.returnToEditProfile(position: position, company: editableOccupation?.company, deleted: true)
        }
    }
    
}

// MARK: - Private Functions
private extension EditOccupationViewModel {
    
    func displayDelete() {
        if type == .editOccupation {
            delegate?.displayDelete()
        }
    }
    
    func checkValidSave() {
        guard let newPosition = editableOccupation?.position, newPosition.isValidString,
              let position = occupation?.position, position.isValidString else {
                if let newPosition = editableOccupation?.position {
                    canSave = newPosition.isValidString
                }
                return
        }
        
        canSave = !(newPosition == position && occupation?.company == editableOccupation?.company)
    }

}
