//
//  FilterItemsDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

protocol FilterItemsDelegate: class {
    
    /// Notifies delegate that items loaded successfully.
    func itemsLoadingSuccessful()
    
    /// Notifies delegate that there was an error loading items.
    ///
    /// - Parameter error: Optional error to display.
    func itemsLoaded(withError error: Error?)
    
}
