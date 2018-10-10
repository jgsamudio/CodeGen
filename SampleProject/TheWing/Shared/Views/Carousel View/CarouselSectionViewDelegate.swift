//
//  CarouselSectionViewDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

protocol CarouselSectionViewDelegate: class, UICollectionViewDataSource {
    
    /// Notifies delegate when the page at given index was scrolled to.
    ///
    /// - Parameter index: Index of page.
    func didScrollToPage(_ index: Int)
    
    /// Notifies delegate that optional action button was selected.
    func didSelectAction()
    
    /// Notifies delegate that item at index path was selected.
    ///
    /// - Parameter indexPath: Index path of item.
    func didSelectItemAtIndexPath(_ indexPath: IndexPath)
    
}

extension CarouselSectionViewDelegate {
    
    // MARK: - Public Functions
    
    func didScrollToPage(_ index: Int) {
        
    }
    
    func didSelectAction() {
        
    }
    
    func didSelectItemAtIndexPath(_ indexPath: IndexPath) {
        
    }
    
}
