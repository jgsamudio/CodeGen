//
//  TagCollectionViewCell.swift
//  TheWing
//
//  Created by Luna An on 3/29/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class TagCollectionViewCell: UICollectionViewCell {

    // MARK: - Private Properties

    private var tagPillView: TagPillView?
    
    // MARK: - Public Functions
    
    /// Sets up a tag collection view cell with a tag string and based on its type.
    ///
    /// - Parameters:
    ///   - theme: The theme.
    ///   - tag: The tag to display.
    ///   - dataSource: The tag datasource.
    func setup(theme: Theme, tag: String, dataSource: TagViewDataSource) {
        setupCollectionViewCell(theme: theme, tag: tag, dataSource: dataSource)
    }
    
    /// Sets up a tag collection view cell with a darker border.
    ///
    /// - Parameters:
    ///   - theme: Theme to use to set up border.
    ///   - tag: Tag label.
    ///   - dataSource: Tag data source.
    func setupDarkTheme(theme: Theme, tag: String, dataSource: TagViewDataSource) {
        setupCollectionViewCell(theme: theme, tag: tag, dataSource: dataSource)
        tagPillView?.layer.borderColor = theme.colorTheme.emphasisQuaternary.cgColor
    }
    
}

// MARK: - Private Functions
private extension TagCollectionViewCell {
    
    func setupCollectionViewCell(theme: Theme, tag: String, dataSource: TagViewDataSource) {
        setupTagPillView(theme: theme)
        tagPillView?.set(tag: tag,
                         backgroundColor: dataSource.cellBackgroundColor(theme: theme),
                         isRemovable: dataSource.isRemovable,
                         isSelectable: dataSource.isSelectable,
                         selected: dataSource.selected)
    }

    func setupTagPillView(theme: Theme) {
        guard tagPillView == nil else {
            return
        }

    // MARK: - Public Properties
    
        let pillView = TagPillView(theme: theme)
        addSubview(pillView)
        pillView.autoPinEdgesToSuperviewEdges()
        tagPillView = pillView
    }
        
}
