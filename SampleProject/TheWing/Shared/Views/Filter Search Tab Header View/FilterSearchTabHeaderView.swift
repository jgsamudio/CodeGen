//
//  FilterSearchTabHeaderView.swift
//  TheWing
//
//  Created by Jonathan Samudio on 6/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

final class FilterSearchTabHeaderView: AccessibilityHeaderView {

    // MARK: - Public Properties

    weak var delegate: FilterSearchTabHeaderViewDelegate?

    lazy var searchBar: FilterSearchBar = {
        let searchBar = FilterSearchBar(theme: theme)
        searchBar.delegate = self
        return searchBar
    }()
    
    // MARK: - Private Properties

    private let headerTitle: String

    private lazy var headerView: TabItemHeaderView = {
        let headerView = TabItemHeaderView(title: headerTitle, theme: theme)
        headerView.borderVisible = false
        headerView.delegate = self
        return headerView
    }()

    // MARK: - Initialization

    init(theme: Theme, headerTitle: String) {
        self.headerTitle = headerTitle
        super.init(theme: theme)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /// Enables accessibility usage for child elements.
    override func enableAccessibility() {
        headerView.enableAccessibility()
    }

    /// Disables accessibility usage for childe elements.
    override func disableAccessibility() {
        headerView.disableAccessibility()
    }

    /// Sets the profile image of the tab bar item header view.
    ///
    /// - Parameter profileImage: Image to set.
    override func set(profileImage: UIImage) {
        self.headerView.set(profileImage: profileImage)
    }
    
    /// Resets search text field.
    override func resetSearchField(hasSearchText: Bool) {
        searchBar.resetSearchField(hasSearchText: hasSearchText)
    }
    
    /// Sets the count on the filters button.
    ///
    /// - Parameter count: Count of filters selected.
    func setFilterCount(_ count: Int) {
        searchBar.setFilterCount(count)
    }
    
}

// MARK: - Private Functions
private extension FilterSearchTabHeaderView {

    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = theme.colorTheme.invertTertiary
        addDividerView(color: theme.colorTheme.tertiary)
        setupHeaderView()
        setupSearchBar()
    }

    func setupHeaderView() {
        addSubview(headerView)
        headerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        headerView.bottomSpacing = 24
    }

    func setupSearchBar() {
        addSubview(searchBar)
        searchBar.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        searchBar.autoPinEdge(.top, to: .bottom, of: headerView)
    }
    
}

// MARK: - TabItemHeaderViewDelegate
extension FilterSearchTabHeaderView: TabItemHeaderViewDelegate {

    func profileImageSelected() {
        delegate?.profileImageSelected()
    }

}

// MARK: - FilterSearchDelegate
extension FilterSearchTabHeaderView: FilterSearchDelegate {

    func filterButtonSelected() {
        delegate?.filterButtonSelected()
    }

    func animateConstraints() {
        headerView.showHeaderItems(show: searchBar.isSearchBarFocused)
        delegate?.animateHeaderConstraints(with: searchBar.isSearchBarFocused ? ViewConstants.navigationBarAnimatedTop : 0)
    }

    func displaySearchResult(with searchText: String?) {
        delegate?.displaySearchResult(with: searchText)
    }
    
    func cancelSearch() {
        delegate?.cancelSearch()
    }
    
}
