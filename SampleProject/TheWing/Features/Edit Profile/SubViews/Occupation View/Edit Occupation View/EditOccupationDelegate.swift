//
//  EditOccupationDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EditOccupationDelegate: EditEmptyOccupationDelegate {

    /// Called when the edit occupation button was selected.
    ///
    /// - Parameter occupation: Occupation that was selected.
    func editOccupationSelected(occupation: Occupation)

    /// Called when the add occupation button is selected.
    func addOccupationSelected()
    
}
