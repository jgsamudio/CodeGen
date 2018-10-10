//
//  SearchOccupationViewDelegate.swift
//  TheWing
//
//  Created by Luna An on 4/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol SearchOccupationViewDelegate: class {
    
    /// Called when the selection from the search result has been added.
    ///
    /// - Parameter selection: The selected search result to add.
    func addSelection(selection: String, type: SearchOccupationType)
    
    ///  Called when the search result should be displayed.
    ///
    /// - Parameter show: Determines if the search result should show.
    func showSearchResult(_ show: Bool)
    
    /// Called when the done button is pressed without selecting a search result or user input.
    func doneWithoutSelection()
    
    /// Called when the results view should be refreshed.
    func refreshResultsView()

}
