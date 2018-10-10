//
//  FilterSearchNavigationView.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/6/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class FilterSearchNavigationView: OverflowingBuildableView {

    // MARK: - Public Properties
    
    weak var delegate: FilterSearchNavigationViewDelegate?
    
    override var isUserInteractionEnabled: Bool {
        didSet {
            searchBar.isUserInteractionEnabled = isUserInteractionEnabled
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var navigationView = NavigationView(theme: theme)

    private lazy var searchBar = FilterSearchBar(theme: theme)
    
    // MARK: - Initialization
    
    override init(theme: Theme) {
        super.init(theme: theme)
        setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    /// Sets the title of the navigation view.
    ///
    /// - Parameter title: Title text.
    func set(title: String) {
        navigationView.set(title: title)
    }
    
    /// Sets the count on the filters button.
    ///
    /// - Parameter count: Count of filters selected.
    func setFilterCount(_ count: Int) {
        searchBar.setFilterCount(count)
    }
    
    /// Resets the search text field.
    ///
    /// - Parameter hasSearchText: Flag to indicate if search text was previous entered.
    func reset(hasSearchText: Bool) {
        searchBar.resetSearchField(hasSearchText: hasSearchText)
    }

}

// MARK: - Private Functions
private extension FilterSearchNavigationView {
    
    func setupDesign() {
        setupNavigationView()
        setupBorder()
        setupSearchBar()
    }
    
    func setupNavigationView() {
        addSubview(navigationView)
        navigationView.delegate = self
        navigationView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
    }
    
    func setupBorder() {
        addDividerView(color: theme.colorTheme.tertiary)
    }
    
    func setupSearchBar() {
        addSubview(searchBar)
        searchBar.delegate = self
        searchBar.autoPinEdge(.top, to: .bottom, of: navigationView, withOffset: 27)
        searchBar.autoPinEdge(toSuperviewEdge: .leading)
        searchBar.autoPinEdge(toSuperviewEdge: .trailing)
        searchBar.autoPinEdge(.bottom, to: .bottom, of: self)
    }
    
}

// MARK: - NavigationViewDelegate
extension FilterSearchNavigationView: NavigationViewDelegate {
    
    func backButtonSelected() {
        delegate?.backButtonSelected()
    }
    
}

// MARK: - FilterSearchDelegate
extension FilterSearchNavigationView: FilterSearchDelegate {
    
    func filterButtonSelected() {
        delegate?.filterButtonSelected()
    }
    
    func animateConstraints() {
        navigationView.showHeaderItems(show: searchBar.isSearchBarFocused)
        delegate?.animateHeaderConstraints(with: searchBar.isSearchBarFocused ? ViewConstants.navigationBarAnimatedTop : 0)
    }
    
    func displaySearchResult(with searchText: String?) {
        delegate?.displaySearchResult(with: searchText)
    }
    
    func cancelSearch() {
        delegate?.cancelSearch()
    }
    
}

