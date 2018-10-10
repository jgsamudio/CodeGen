//
//  EditBiographyViewDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 4/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol EditBiographyViewDelegate: class {
    
    /// Notifies delegate that a change was made to the biography.
    ///
    /// - Parameter text: New text.
    func biographyDidChange(_ text: String?)
    
}
