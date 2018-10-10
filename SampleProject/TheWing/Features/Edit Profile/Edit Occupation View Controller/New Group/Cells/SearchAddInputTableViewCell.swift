//
//  SearchAddInputTableViewCell.swift
//  TheWing
//
//  Created by Luna An on 4/7/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class SearchAddInputTableViewCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private lazy var addInputView: AddInputView = {
    
    // MARK: - Public Properties
    
        let view = AddInputView()
        addSubview(view)
        view.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .leading)
        view.autoPinEdge(toSuperviewEdge: .leading, withInset: ViewConstants.defaultGutter)
        return view
    }()
    
    // MARK: - Public Functions
    
    /// Sets up a result table view cell with a result text.
    ///
    /// - Parameters:
    ///   - theme: The theme.
    ///   - input: The input string to display.
    func setup(theme: Theme, input: String?) {
        addInputView.setup(theme: theme, input: input)
    }
    
}
