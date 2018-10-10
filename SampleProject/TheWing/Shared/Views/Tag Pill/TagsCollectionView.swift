//
//  TagsCollectionView.swift
//  TheWing
//
//  Created by Luna An on 3/29/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class TagsCollectionView: SelfSizingCollectionView {
    
    // MARK: - Initialization
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        registerCell(cellClass: TagCollectionViewCell.self)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Functions
private extension TagsCollectionView {
    
    func setup() {
        backgroundColor = .clear
        isScrollEnabled = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        bounces = false
    }

}
