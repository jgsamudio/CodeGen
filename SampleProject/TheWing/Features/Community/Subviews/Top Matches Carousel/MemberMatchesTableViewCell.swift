//
//  MemberMatchesTableViewCell.swift
//  TheWing
//
//  Created by Ruchi Jain on 8/27/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class MemberMatchesTableViewCell: UITableViewCell {
    
    // MARK: - Private Properties

    private var carouselSectionView: CarouselSectionView?
    
    // MARK: - Public Functions

    /// Sets the table view cell with content and theme.
    ///
    /// - Parameters:
    ///   - title: Title of view.
    ///   - buttonTitle: Button title.
    ///   - dataSourcesCount: Count of data sources.
    ///   - delegate: Collection view data source.
    ///   - theme: Theme.
    func setup(title: String,
               buttonTitle: String?,
               dataSourcesCount: Int,
               delegate: CarouselSectionViewDelegate,
               theme: Theme,
               isLoading: Bool) {
        setup(theme: theme)
        carouselSectionView?.delegate = delegate
        carouselSectionView?.setup(title: title,
                                   buttonTitle: buttonTitle,
                                   dataSourcesCount: dataSourcesCount,
                                   isLoading: isLoading)
    }
    
}

// MARK: - Private Functions
private extension MemberMatchesTableViewCell {
    
    func setup(theme: Theme) {
        guard carouselSectionView == nil else {
            return
        }
        
    // MARK: - Public Properties
    
        let sectionView = CarouselSectionView(theme: theme,
                                              headerInsets: UIEdgeInsets(top: 20, left: 24, bottom: 10, right: 24))

        sectionView.backgroundColor = theme.colorTheme.secondary
        sectionView.registerCell(cellClass: MemberMatchCollectionViewCell.self)
        sectionView.itemSize = CGSize(width: UIScreen.width - (UIScreen.isSmall ? 41 : 59),
                                      height: UIScreen.isSmall ? 236 : 216)
        sectionView.interitemSpacing = 8
        sectionView.collectionViewInset = UIScreen.isSmall ? UIEdgeInsets(left: 16, right: 16) :
            UIEdgeInsets(left: 24, right: 24)
        contentView.addSubview(sectionView)
        NSLayoutConstraint.autoSetPriority(.required - 1) {
            sectionView.autoPinEdgesToSuperviewEdges()
        }
        carouselSectionView = sectionView
        selectionStyle = .none
    }
    
}
