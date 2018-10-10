//
//  EditableOccupations.swift
//  TheWing
//
//  Created by Luna An on 8/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Shared class for editable occupations.
final class EditableOccupations {
    
    // MARK: - Public Properties

    /// Editable occupations.
    var occupations: [Occupation] = []
    
    /// Occupations as a set
    var occupationsSet: Set<Occupation> {
        return Set<Occupation>(occupations)
    }
    
    // MARK: - Public Functions

    /// Updates the occupation view with newly configured occupations.
    ///
    /// - Parameters:
    ///   - occupation: The occupation to add/edit.
    ///   - originalOccupation: The original occupation to compare to.
    ///   - deleted: Flag if the delete action was requested.
    func updateOccupations(occupation: Occupation?,
                           originalOccupation: Occupation?,
                           deleted: Bool,
                           delegate: EditOccupationBaseDelegate?) {
        let occupations: [Occupation]
        if deleted {
            occupations = deleteOccupation(originalOccupation: originalOccupation)
        } else {
            occupations = configureOccupations(occupation: occupation, originalOccupation: originalOccupation)
        }
        if occupations.isEmpty {
            delegate?.displayEmptyOccupationView()
        } else {
            delegate?.displayOccupationItemView(occupations: occupations)
        }
        
        self.occupations = occupations
    }
    
}

// MARK: - Private Functions
private extension EditableOccupations {
    
    func configureOccupations(occupation: Occupation?, originalOccupation: Occupation?) -> [Occupation] {
        guard let occupation = occupation else {
            return occupations
        }
        
        guard let originalOccupation = originalOccupation else {
            occupations.append(occupation)
            return occupations
        }
        
        if let index = occupations.index(where: { $0 == originalOccupation }) {
            occupations.remove(at: index)
            occupations.insert(occupation, at: index)
        }
        
        return occupations
    }
    
    func deleteOccupation(originalOccupation: Occupation?) -> [Occupation] {
        if let index = occupations.index(where: { $0 == originalOccupation }) {
            occupations.remove(at: index)
        }
        return occupations
    }
    
}
