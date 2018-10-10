//
//  SearchTagsViewModel.swift
//  TheWing
//
//  Created by Ruchi Jain on 4/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class SearchTagsViewModel {

    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    weak var delegate: SearchTagsViewDelegate?

    /// Binding delegate for the previous view.
    weak var searchDelegate: SearchTagsDelegate?
    
    /// Search bar helper text.
    var searchBarHelperText: String {
        return type.helperText
    }

    /// Search results tags.
    var tags: [String] = []
    
    /// Tag view data source.
    var dataSource: TagViewDataSource {
        switch type {
        case .offers:
            return ProfileTagType.offers((isSelectable: true, isRemovable: false))
        case .interests:
            return ProfileTagType.interests((isSelectable: true, isRemovable: false))
        case .asks:
            return ProfileTagType.asks((isSelectable: true, isRemovable: false))
        }
    }
    
    // MARK: - Private Properties
    
    private let dependencyProvider: DependencyProvider
    
    private let type: ProfileTagType
    
    private static let pageSize = 30
    
    private var userInput: String? {
        didSet {
            delegate?.setUserInput(userInput)
        }
    }

    // MARK: - Initialization
    
    init(type: ProfileTagType, dependencyProvider: DependencyProvider) {
        self.type = type
        self.dependencyProvider = dependencyProvider
    }

    // MARK: - Public Functions
    
    /// Determines if search bar text should change.
    ///
    /// - Parameters:
    ///   - current: Current search bar text.
    ///   - range: Range of new text.
    ///   - text: Replacement text.
    /// - Returns: True, if should change. False, otherwise.
    func shouldChangeText(current: String?, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let searchBarText = current else {
            return true
        }
        
        return (searchBarText as NSString).replacingCharacters(in: range, with: text).count <= 30
    }
    
    /// Validates the search entry.
    ///
    /// - Parameter searchText: The search text to validate.
    func validateSearchEntry(searchText: String) {
        if searchText.isValidString {
            userInput = searchText.whitespaceTrimmed
            if searchText.count > 1 {
                searchAutoCompleteEntriesWith(subString: searchText.whitespaceTrimmed)
            }
        } else {
            userInput = nil
            tags.removeAll()
            delegate?.refreshView()
        }
    }
    
    /// Called when a tag was selected from the collection view.
    ///
    /// - Parameter indexPath: Index path of the tag.
    func tagSelected(at indexPath: IndexPath) {
        searchDelegate?.add(tag: tags[indexPath.row], type: type)
        delegate?.dismissView()
    }
    
    /// Called when the user opts to enter custom tag.
    @objc func addUserInput() {
        guard let userInput = userInput else {
            return
        }
        
        searchDelegate?.add(tag: userInput, type: type)
        delegate?.dismissView()
    }
    
}

// MARK: - Private Functions
private extension SearchTagsViewModel {
    
    func searchAutoCompleteEntriesWith(subString: String) {
        tags.removeAll()
        delegate?.refreshView()
        let loader = dependencyProvider.networkProvider.searchResultsLoader
        switch type {
        case .asks:
            loader.searchAsks(pageSize: SearchTagsViewModel.pageSize, page: 1, query: subString) { (result) in
                guard let results = result.value?.data.asks else {
                    return
                }
                self.configure(results: results)
            }
        case .offers:
            loader.searchOffers(pageSize: SearchTagsViewModel.pageSize, page: 1, query: subString) { (result) in
                guard let results = result.value?.data.offers else {
                    return
                }
                self.configure(results: results)
            }
        case .interests:
            loader.searchInterests(pageSize: SearchTagsViewModel.pageSize, page: 1, query: subString) { (result) in
                guard let results = result.value?.data.interests else {
                    return
                }
                self.configure(results: results)
            }
        }
    }
    
    func configure(results: [SearchResult]) {
        results.forEach { tags.append($0.name.capitalized) }
        delegate?.refreshView()
    }
    
}
