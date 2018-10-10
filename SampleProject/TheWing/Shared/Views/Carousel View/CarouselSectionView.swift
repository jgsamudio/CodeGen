//
//  CarouselSectionView.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class CarouselSectionView: BuildableView {

    // MARK: - Public Properties
    
    /// Collection view data source.
    weak var delegate: CarouselSectionViewDelegate? {
        didSet {
            collectionView.dataSource = delegate
        }
    }
    
    /// Collection view flow layout's item size.
    var itemSize: CGSize = CGSize(width: UIScreen.width - 48, height: UIScreen.isSmall ? 293 : 278) {
        didSet {
            flowLayout.itemSize = itemSize
            collectionViewHeight?.constant = itemSize.height
        }
    }
    
    /// Collection view flow layout's minimum interitem spacing.
    var interitemSpacing: CGFloat = 12 {
        didSet {
            flowLayout.minimumInteritemSpacing = interitemSpacing
        }
    }
    
    /// Content inset for collection view.
    var collectionViewInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24) {
        didSet {
            collectionView.contentInset = collectionViewInset
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerContainer, collectionView, pagingContainer])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.contentInset = collectionViewInset
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.layer.masksToBounds = false
        collectionView.clipsToBounds = false
        return collectionView
    }()
    
    private lazy var flowLayout: CarouselCollectionViewFlowLayout = {
        let flowLayout = CarouselCollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = interitemSpacing
        flowLayout.itemSize = itemSize
        return flowLayout
    }()
    
    private lazy var sectionHeader = SectionHeaderActionView(theme: theme)
    
    private lazy var headerContainer: UIView = {
        let view = UIView()
        view.addSubview(sectionHeader)
        sectionHeader.autoPinEdgesToSuperviewEdges(with: headerInsets)
        return view
    }()
    
    private lazy var pageControl = InfinityPageControl()
    
    private lazy var pagingContainer: UIView = {
        let view = UIView()
        view.addSubview(pageControl)
        pageControl.autoCenterInSuperview()
        view.autoSetDimension(.height, toSize: 56)
        return view
    }()
    
    private var collectionViewHeight: NSLayoutConstraint?

    private let headerInsets: UIEdgeInsets
    
    // MARK: - Initialization
    
    init(theme: Theme, headerInsets: UIEdgeInsets) {
        self.headerInsets = headerInsets
        super.init(theme: theme)
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions
    
    /// Sets up view with given title.
    ///
    /// - Parameters:
    ///   - title: Title of section.
    ///   - buttonTitle: Optional button title.
    ///   - dataSourcesCount: Total count of data sources in section.
    ///   - isLoading: Determines if the view should load.
    func setup(title: String, buttonTitle: String? = nil, dataSourcesCount: Int, isLoading: Bool = false) {
        sectionHeader.setup(title: title, buttonTitle: buttonTitle, target: self, selector: #selector(didSelectAction))
        pageControl.numberOfPages = dataSourcesCount
        pageControl.alpha = dataSourcesCount > 1 ? 1 : 0
        collectionView.reloadData()
        pageControl.currentPage = flowLayout.currentCenteredPage ?? 0
        delegate?.didScrollToPage(flowLayout.currentCenteredPage ?? 0)
        startShimmer(isLoading)
    }

    /// Registers a cell class to the carousel's collection view.
    ///
    /// - Parameter cellClass: UICollectionViewCell class that conforms to reusable view protocol.
    func registerCell<T: ReusableView>(cellClass: T.Type) {
        collectionView.registerCell(cellClass: cellClass)
    }
    
}

// MARK: - Private Functions
private extension CarouselSectionView {
    
    func setupDesign() {
        collectionViewHeight = collectionView.autoSetDimension(.height, toSize: itemSize.height)
        addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges()
    }
    
    func scrollToPage(index: Int, animated: Bool) {
        let pageOffset = CGFloat(index) * flowLayout.pageWidth - collectionView.contentInset.left
        let proposedContentOffset = CGPoint(x: pageOffset, y: collectionView.contentOffset.y)
        let shouldAnimate = fabs(collectionView.contentOffset.x - pageOffset) > 1 ? animated : false
        collectionView.setContentOffset(proposedContentOffset, animated: shouldAnimate)
    }
    
    @objc func didSelectAction() {
        delegate?.didSelectAction()
    }
    
}

// MARK: - ShimmerProtocol
extension CarouselSectionView: ShimmerProtocol {

    var hiddenViews: [UIView] {
        return [pageControl]
    }

}

// MARK: - UICollectionViewDelegate
extension CarouselSectionView: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let currentPage = flowLayout.currentCenteredPage, currentPage != pageControl.currentPage else {
            return
        }
        
        pageControl.currentPage = currentPage
        delegate?.didScrollToPage(currentPage)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard flowLayout.currentCenteredPage != indexPath.row else {
            delegate?.didSelectItemAtIndexPath(indexPath)
            return
        }
        
        scrollToPage(index: indexPath.row, animated: true)
    }
    
}
