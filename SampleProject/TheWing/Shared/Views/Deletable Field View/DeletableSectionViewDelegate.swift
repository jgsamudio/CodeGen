//
//  DeletableSectionViewDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/21/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol DeletableSectionViewDelegate: class {
    
    /// Notifies delegate that delete action was attemped in given view.
    ///
    /// - Parameter deletableSectionView: Deletable Section View where delete action took place.
    func deleteSelected(_ deletableSectionView: DeletableSectionView)
    
}
