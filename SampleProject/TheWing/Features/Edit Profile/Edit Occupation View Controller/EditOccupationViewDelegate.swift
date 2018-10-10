//
//  EditOccupationViewDelegate.swift
//  TheWing
//
//  Created by Jonathan Samudio on 4/2/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

protocol EditOccupationViewDelegate: class {

    /// Displays the occupation with the given parameters.
    ///
    /// - Parameters:
    ///   - position: Position to display.
    ///   - company: Company to display.
    func display(position: String?, company: String?)
    
    /// Sets the selected occupation item. ( e.g. position or company )
    ///
    /// - Parameters:
    ///   - selection: Selected occupation item based on the type.
    ///   - type: Search occupation type.
    func set(selection: String?, type: SearchOccupationType)
    
    /// Returns to the edit profile screen.
    ///
    /// - Parameters:
    ///   - position: Position to add.
    ///   - company: Company to add.
    ///   - deleted: Flag if the delete action was requested.
    func returnToEditProfile(position: String, company: String?, deleted: Bool)
    
    /// Indicates if the occupation can be saved.
    ///
    /// - Parameter canSave: Flag to determine if the added occupation can be saved.
    func canSaveOccupation(_ canSave: Bool)
    
    /// Indicates if the delete button should be displayed.
    func displayDelete()
    
}
