//
//  EditOccupationBaseDelegate.swift
//  TheWing
//
//  Created by Luna An on 7/31/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EditOccupationBaseDelegate: class {
    
    /// Sets occupation with user selected/entered occupation information.
    ///
    /// - Parameters:
    ///   - occupation: The new occupation to add.
    ///   - originalOccupation: The original occupation to compare to if edited.
    ///   - deleted: Flag if the delete action was requested.
    func setOccupation(occupation: Occupation?, originalOccupation: Occupation?, deleted: Bool)
    
    /// Displays the empty occupation view.
    func displayEmptyOccupationView()
    
    /// Displays the occupation view with the given parameters.
    ///
    /// - Parameter occupations: Occupations to load.
    func displayOccupationItemView(occupations: [Occupation])
    
}
