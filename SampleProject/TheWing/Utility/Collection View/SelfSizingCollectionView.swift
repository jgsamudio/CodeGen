//
//  SelfSizingCollectionView.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Collection view that sets its intrinsic content size to the collection view's content size.
class SelfSizingCollectionView: UICollectionView {
    
    // MARK: - Public Properties
    
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
    
    // MARK: - Public Functions
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !bounds.size.equalTo(intrinsicContentSize) {
            invalidateIntrinsicContentSize()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
    }
    
}
