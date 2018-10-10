//
//  SearchTagsViewDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 4/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

protocol SearchTagsViewDelegate: class {

    /// Called when the tags view should be refreshed.
    func refreshView()
    
    /// Updates the view with user input.
    ///
    /// - Parameter text: Text.
    func setUserInput(_ text: String?)
    
    /// Called when the view should be dismissed.
    func dismissView()
    
}
