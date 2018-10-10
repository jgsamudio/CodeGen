//
//  SearchOccupationViewModel.swift
//  TheWing
//
//  Created by Luna An on 4/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class SearchOccupationViewModel {
    
    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    weak var delegate: SearchOccupationViewDelegate?
    
    let type: SearchOccupationType
    
    var filteredResults: [String] = []
    
    var userInput: String?
    
    /// Search bar helper text.
    var searchBarHelperText: String {
        return type.helperText
    }
    
    // MARK: - Private Properties
    
    private let dependencyProvider: DependencyProvider
    
    // MARK: - Constants
    
    fileprivate static let pageSize: Int = 30
    
    // MARK: - Initialization
    
    init(dependencyProvider: DependencyProvider, type: SearchOccupationType) {
        self.dependencyProvider = dependencyProvider
        self.type = type
    }
    
    // MARK: - Public Functions
    
    /// Adds user entered input.
    func addUserInput() {
        guard let input = userInput else {
            return
        }
        delegate?.addSelection(selection: input, type: type)
    }
    
    /// Adds user selection from the search result.
    ///
    /// - Parameter searchResult: The selected search result.
    func addUserSelection(searchResult: String) {
        delegate?.addSelection(selection: searchResult, type: type)
    }
    
    /// Validates the search entry.
    ///
    /// - Parameter searchText: The search text to validate.
    func validateSearchEntry(searchText: String) {
        if searchText.isValidString {
            userInput = searchText
            delegate?.showSearchResult(true)
            if searchText.count > 1 {
                searchAutoCompleteEntriesWith(subString: searchText)
            } else {
                delegate?.refreshResultsView()
            }
        } else {
            filteredResults.removeAll()
            userInput = nil
            delegate?.showSearchResult(false)
            delegate?.refreshResultsView()
        }
    }
    
    /// Called to indicate the done button is pressed from the keyboard.
    func doneButtonPressed() {
        if type == .companies {
            delegate?.doneWithoutSelection()
        }
    }
        
}

// MARK: - Private Functions
private extension SearchOccupationViewModel {
    
    func searchAutoCompleteEntriesWith(subString: String) {
        filteredResults.removeAll()
        delegate?.refreshResultsView()
        
        let loader = dependencyProvider.networkProvider.searchResultsLoader
        switch type {
        case .companies:
            loader.searchCompanies(pageSize: SearchOccupationViewModel.pageSize,
                                   page: 1,
                                   query: subString) { [weak self] (result) in
                self?.handleResultsResponse(success: result.isSuccess, list: result.value?.data.companies)
            }
        case .positions:
            loader.searchPositions(pageSize: SearchOccupationViewModel.pageSize,
                                   page: 1,
                                   query: subString) { [weak self] (result) in
                self?.handleResultsResponse(success: result.isSuccess, list: result.value?.data.positions)
            }
        }
    }
    
    private func handleResultsResponse(success: Bool, list: [SearchResult]?) {
        if success, let results = list {
            filteredResults += results.map { $0.name }.filter { !filteredResults.contains($0) }
            delegate?.refreshResultsView()
        }
    }
        
}
