//
//  NoResultsTableViewCell.swift
//  TheWing
//
//  Created by Luna An on 8/28/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class NoResultsTableViewCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private var noResultsView: NoResultsView?
    
    // MARK: - Public Functions
    
    /// Sets member cell view with given inputs.
    ///
    /// - Parameters:
    ///   - theme: Theme.
    ///   - delegate: No result delegate.
    func setup(theme: Theme, delegate: NoResultDelegate?) {
        guard self.noResultsView?.superview == nil else {
            return
        }
        backgroundColor = .clear
        selectionStyle = .none
    
    // MARK: - Public Properties
    
        let noResultsView = NoResultsView(theme: theme, delegate: delegate)
        contentView.addSubview(noResultsView)
        noResultsView.autoPinEdgesToSuperviewEdges()
        noResultsView.updateTopConstant(constant: UIScreen.isSmall ? 35 : 50)
        self.noResultsView = noResultsView
    }
    
}
