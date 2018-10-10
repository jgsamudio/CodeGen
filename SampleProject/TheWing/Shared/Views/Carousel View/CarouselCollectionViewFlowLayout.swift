//
//  CarouselCollectionViewFlowLayout.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Collection view flow layout resulting in horizontal carousel effect.
final class CarouselCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Public Properties
    
    /// Page width.
    var pageWidth: CGFloat {
        return itemSize.width + minimumInteritemSpacing
    }
    
    /// Calculates the current centered page.
    var currentCenteredPage: Int? {
        guard let collectionView = collectionView else {
            return nil
        }
        
        let currentCenteredPoint = CGPoint(x: collectionView.contentOffset.x + collectionView.bounds.width / 2,
                                           y: collectionView.contentOffset.y + collectionView.bounds.height / 2)
        return collectionView.indexPathForItem(at: currentCenteredPoint)?.row
    }
    
    override var scrollDirection: UICollectionViewScrollDirection {
        didSet {
            assert(scrollDirection == .horizontal, "CarouselCollectionViewFlowLayout: Invalid Scroll Direction")
        }
    }
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scrollDirection = .horizontal
    }
    
    // MARK: - Public Functions
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }
        
        let proposedRect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: collectionView.contentOffset.y),
                                  size: collectionView.bounds.size)
        
        guard let layoutAttributes = layoutAttributesForElements(in: proposedRect),
            let candidateAttributesForRect = attributesForRect(
                collectionView: collectionView,
                layoutAttributes: layoutAttributes,
                proposedContentOffset: proposedContentOffset
            ) else {
                return proposedContentOffset
        }
        
        var newOffset = candidateAttributesForRect.center.x - collectionView.bounds.size.width / 2
        let offset = newOffset - collectionView.contentOffset.x
        
        if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
            let pageWidth = itemSize.width + minimumInteritemSpacing
            newOffset += velocity.x > 0 ? pageWidth : -pageWidth
        }
        
        return CGPoint(x: newOffset, y: proposedContentOffset.y)
    }
    
}

// MARK: - Private Functions
private extension CarouselCollectionViewFlowLayout {
    
    func attributesForRect(collectionView: UICollectionView,
                           layoutAttributes: [UICollectionViewLayoutAttributes],
                           proposedContentOffset: CGPoint) -> UICollectionViewLayoutAttributes? {
        var candidateAttributes: UICollectionViewLayoutAttributes?
        let proposedCenterOffset = proposedContentOffset.x + collectionView.bounds.size.width / 2
        
        for attributes in layoutAttributes {
            guard attributes.representedElementCategory == .cell else {
                continue
            }
            guard candidateAttributes != nil else {
                candidateAttributes = attributes
                continue
            }
            
            if fabs(attributes.center.x - proposedCenterOffset)
                < fabs(candidateAttributes!.center.x - proposedCenterOffset) {
                candidateAttributes = attributes
            }
        }
        return candidateAttributes
    }
    
}
