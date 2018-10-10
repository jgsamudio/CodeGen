//
//  MemberSearchSegmentedSectionHeader.swift
//  TheWing
//
//  Created by Luna An on 8/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class MemberSearchSegmentedSectionHeader: UITableViewHeaderFooterView {
    
    // MARK: - Private Properties
    
    private var segmentedView: MembersSearchSegmentedView?
    
    // MARK: - Public Functions
    
    /// Sets up the header view.
    ///
    /// - Parameters:
    ///   - theme: Theme.
    ///   - count: Member count to display.
    ///   - selectedSegmentIndex: Index of selected segment in segment controller.
    ///   - delegate: MembersSearchSegmentedViewDelegate
    func setup(theme: Theme, count: Int, selectedSegmentIndex: Int, delegate: MembersSearchSegmentedViewDelegate) {
        defer {
            segmentedView?.setMembersCount(withCount: count, selectedSegmentIndex: selectedSegmentIndex)
        }
        
        guard segmentedView?.superview == nil else {
            return
        }
        
    // MARK: - Public Properties
    
        let searchSegmentedView = MembersSearchSegmentedView(theme: theme)
        searchSegmentedView.delegate = delegate
        contentView.addSubview(searchSegmentedView)
        searchSegmentedView.autoPinEdgesToSuperviewEdges()
        segmentedView = searchSegmentedView
        contentView.backgroundColor = theme.colorTheme.invertPrimary
    }

}
