//
//  AnnouncementsView.swift
//  TheWing
//
//  Created by Paul Jones on 7/10/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class HomeAnnouncementsView: BuildableView {
    
    // MARK: - Public Properties
    
    weak var delegate: HomeAnnouncementsViewDelegate?
    
    var dataSources = [AnnouncementData]() {
        didSet {
            pageControl.numberOfPages = dataSources.count
            collectionView.reloadData()
        }
    }
    
    // MARK: - Private Properties
    
    private var sectionHeaderView: SectionHeaderView!
    
    private var sectionHeaderStackView: UIStackView!
    
    private var mainStackView: UIStackView!
    
    private var topSpacingView = UIView()
    
    private var sectionHeaderLeftSpacerView = UIView()
    
    private var flowLayout = CarouselCollectionViewFlowLayout()
    private var pagingContainer = UIView()
    private var pageControl = InfinityPageControl(forAutoLayout: ())
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.registerCell(cellClass: HomeAnnouncementsCollectionViewCell.self)
        collectionView.backgroundColor = theme.colorTheme.invertPrimary
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: leftAndRightInset,
                                                   bottom: 0,
                                                   right: leftAndRightInset)
        collectionView.layer.masksToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var didSetupConstraints = false
    
    private var indexOfCellBeforeDragging = 0
    
    private var indexOfCurrentCell: Int {
        return Int(round(collectionView.contentOffset.x / itemSize.width))
    }
    private var itemSize: CGSize {
        return CGSize(width: collectionView.frame.size.width - 70, height: collectionView.frame.size.height)
    }
    
    // MARK: - Constants
    
    private let leftAndRightInset: CGFloat = 24
    
    // MARK: - Initialization
    
    init(theme: Theme, delegate: HomeAnnouncementsViewDelegate) {
        self.delegate = delegate
        super.init(theme: theme)
        backgroundColor = theme.colorTheme.invertPrimary
        flowLayout.scrollDirection = .horizontal
        pagingContainer.addSubview(pageControl)
        sectionHeaderView = SectionHeaderView(theme: theme)
        sectionHeaderView.set(title: HomeLocalization.annoucementsTitle)
        sectionHeaderStackView = UIStackView(arrangedSubviews: [sectionHeaderLeftSpacerView, sectionHeaderView],
                                             axis: .horizontal,
                                             distribution: .fill,
                                             alignment: .fill)
        mainStackView = UIStackView(arrangedSubviews: [topSpacingView,
                                                       sectionHeaderStackView,
                                                       collectionView,
                                                       pagingContainer],
                                    axis: .vertical,
                                    distribution: .fill,
                                    alignment: .fill)
        addSubview(mainStackView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    override func updateConstraints() {
        if didSetupConstraints == false {
            pageControl.autoCenterInSuperview()
            mainStackView.spacing = 15
            mainStackView.autoPinEdgesToSuperviewEdges()
            collectionView.autoSetDimension(.height, toSize: 326)
            pagingContainer.autoSetDimension(.height, toSize: 50)
            sectionHeaderLeftSpacerView.autoSetDimension(.width, toSize: leftAndRightInset)
            pageControl.autoSetDimension(.height, toSize: 61)
            topSpacingView.autoSetDimension(.height, toSize: 8)
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

}

// MARK: - UICollectionViewDataSource
extension HomeAnnouncementsView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeAnnouncementsCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        if indexPath.row < dataSources.count {
            cell.setup(data: dataSources[indexPath.row], theme: theme)
        }
        return cell
    }
    
}

// MARK: - UIScrollViewDelegate
extension HomeAnnouncementsView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let currentPage = flowLayout.currentCenteredPage, currentPage != pageControl.currentPage else {
            return
        }
        
        pageControl.currentPage = currentPage
    }

}

// MARK: - UICollectionViewDelegate
extension HomeAnnouncementsView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if flowLayout.currentCenteredPage != indexPath.row {
            let pageOffset = CGFloat(indexPath.row) * itemSize.width - collectionView.contentInset.left
            let proposedContentOffset = CGPoint(x: pageOffset, y: collectionView.contentOffset.y)
            let shouldAnimate = fabs(collectionView.contentOffset.x - pageOffset) > 1 ? true : false
            collectionView.setContentOffset(proposedContentOffset, animated: shouldAnimate)
        } else {
            delegate?.didSelectItemAt(indexPath)
        }
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeAnnouncementsView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        flowLayout.itemSize = itemSize
        return itemSize
    }

}
