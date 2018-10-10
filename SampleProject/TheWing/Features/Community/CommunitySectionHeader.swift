//
//  CommunitySectionHeader.swift
//  TheWing
//
//  Created by Luna An on 8/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class CommunitySectionHeader: UITableViewHeaderFooterView {
    
    // MARK: - Private Properties
    
    private var sectionHeader: SectionHeaderView?
    
    // MARK: - Public Functions
    
    /// Sets up the header view.
    ///
    /// - Parameters:
    ///   - theme: Theme.
    ///   - title: Title to display.
    func setup(theme: Theme, title: String, isLoading: Bool) {
        defer {
            sectionHeader?.set(title: title)
            sectionHeader?.setShimmer(isLoading)
        }
        
        guard sectionHeader?.superview == nil else {
            return
        }
        
    // MARK: - Public Properties
    
        let sectionHeaderView = SectionHeaderView(theme: theme)
        contentView.addSubview(sectionHeaderView)
        sectionHeaderView.autoPinEdge(toSuperviewEdge: .top, withInset: 32)
        sectionHeaderView.autoPinEdge(toSuperviewEdge: .leading, withInset: ViewConstants.defaultGutter)
        sectionHeaderView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        sectionHeader = sectionHeaderView
        contentView.backgroundColor = theme.colorTheme.invertPrimary
    }

}
