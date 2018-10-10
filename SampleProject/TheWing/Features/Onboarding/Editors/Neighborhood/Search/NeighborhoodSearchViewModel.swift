//
//  NeighbordhoodSearchViewModel.swift
//  TheWing
//
//  Created by Paul Jones on 8/3/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class NeighborhoodSearchViewModel {
    
    // MARK: - Public Properties

    weak var delegate: NeighborhoodSearchViewDelegate?
    
    /// The results ready to be displayed in a view.
    var results: [String] = []
    
    // MARK: - Private Properties

    private let dependencyProvider: DependencyProvider
    
    // MARK: - Initialization

    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
    
    // MARK: - Public Functions

    /// Search for a neighborhood given a typehead. Will get informed of updates via `refresh`.
    ///
    /// - Parameter typeahead: What has the user typed so far?
    func search(with typeahead: String) {
        if typeahead.count > 2 {
            dependencyProvider.networkProvider.searchResultsLoader.searchNeighborhoods(with:
            typeahead) { [weak self] (result) in
                guard let strongSelf = self else { return }
                strongSelf.results = result.value?.data.neighborhoods ?? []
                strongSelf.delegate?.refresh()
            }
        } else {
            clear()
        }
    }
    
    /// Clears the results and calls refresh.
    func clear() {
        results = []
        delegate?.refresh()
    }
    
}
