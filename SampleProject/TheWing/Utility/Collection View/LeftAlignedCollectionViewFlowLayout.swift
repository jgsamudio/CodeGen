//
//  LeftAlignedCollectionViewFlowLayout.swift
//  TheWing
//
//  Created by Luna An on 3/31/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Left aligned collection view flow layout.
final class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Public Functions

    /// Creates left aligned collection view flow layout by detecting a new line from the Y position of the new element.
    ///
    /// - Parameter rect: The rectangle specified in the collection view’s coordinate system containing the target views.
    /// - Returns: Array of layout attributes instances for all views (e.g. cells) in the given rect if available.
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
    // MARK: - Public Properties
    
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = 0
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
    
}
