//
//  EditTagsSectionViewDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 4/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

protocol EditTagsSectionViewDelegate: class, UICollectionViewDelegate {
    
    /// Notifies delegate that add tags action was attempted.
    ///
    /// - Parameter type: Profile tag type.
    func addNewTags(type: ProfileTagType)
    
}
