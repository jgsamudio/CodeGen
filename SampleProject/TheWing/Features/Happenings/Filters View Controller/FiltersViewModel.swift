//
//  FiltersViewModel.swift
//  TheWing
//
//  Created by Ruchi Jain on 4/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

typealias FilterSections = [String: PillDataSources]

final class FiltersViewModel {
    
    // MARK: - Public Properties
    
    /// Binding delegate for the view model.
    weak var delegate: FiltersViewDelegate?
    
    /// Delegate to save changes made to filters.
    weak var filtersDelegate: FiltersDelegate?
    
    /// Filter title.
    var title: String {
        return type.title
    }
    
    // MARK: - Private Properties
    
    private var filterOptions = SectionedFilterParameters()
    
    private var selectedFilterOptions = SectionedFilterParameters() {
        didSet {
            updateRemoveAction()
        }
    }
    
    private let dependencyProvider: DependencyProvider
    
    private let type: FilterType
    
    // MARK: - Initialization
    
    init(dependencyProvider: DependencyProvider, type: FilterType) {
        self.dependencyProvider = dependencyProvider
        self.type = type
    }
    
    // MARK: - Public Functions
    
    /// Loads filters.
    func loadFilters() {
        switch type {
        case .events:
            loadEventsFilters()
        case .community, .attendees:
            loadCommunityFilters()
        }
    }
    
    /// Removes all filter options from array of selected options.
    @objc func clearAll() {
        selectedFilterOptions.keys.forEach {
            selectedFilterOptions[$0]?.removeAll()
            setDataSources(in: $0)
        }
        loadResultsCount()
    }
    
    /// Completion action for tapping filter in given section.
    ///
    /// - Parameters:
    ///   - section: Section key.
    ///   - indexPath: Index path of filter option.
    func selectFilter(in section: String, at indexPath: IndexPath) {
        guard let filter = filterOptions[section]?[indexPath.item] else {
            return
        }
        
        if selectedFilterOptions.keys.contains(section) {
            if let index = selectedFilterOptions[section]?.index(of: filter) {
                selectedFilterOptions[section]?.remove(at: index)
            } else {
                selectedFilterOptions[section]?.append(filter)
            }
        } else {
            selectedFilterOptions[section] = [filter]
        }
        
        setDataSources(in: section)
        loadResultsCount()
    }
    
    /// Event handler for save action.
    @objc func save() {
        delegate?.isLoading(loading: true)
        let count = selectedFilterOptions.map { $0.value.count }.sum()
        filtersDelegate?.editedFilters(selectedFilterOptions, count: count)
    }
    
}

// MARK: - Private Functions
private extension FiltersViewModel {
    
    func configure(_ filterSections: [FilterSection]?) {
        guard let filterSections = filterSections else {
            return
        }
        
        filterSections.forEach {
            filterOptions[$0.section] = $0.filters
        }
        
        var sections = FilterSections()
        filterOptions.forEach {
            let dataSources = Array(repeating: FilterTagType(selected: false), count: $0.value.count)
            sections[$0.key] = ($0.value.map { $0.name }, dataSources)
        }
        delegate?.displaySections(sections)
        
        setSelectedFiltersFromCache()
        loadResultsCount()
    }
    
    func setDataSources(in section: String) {
        guard let filters = filterOptions[section] else {
            return
        }
        
        guard let selectedFilters = selectedFilterOptions[section] else {
            return
        }
        
        let dataSources = filters.map { FilterTagType(selected: selectedFilters.contains($0)) }
        let tagNames = filters.map { $0.name }
        delegate?.updateSection(section, dataSources: (tagNames: tagNames, tagViewSources: dataSources))
    }
    
    func updateRemoveAction() {
        let isSelected = !selectedFilterOptions.map { $0.value.isEmpty }.all(true)
        delegate?.setRemoveAllEnabled(isSelected)
    }
    
    func loadResultsCount() {        
        let filters = FilterFormatter.formatFilter(selectedFilterOptions)
        delegate?.isLoading(loading: true)
        filtersDelegate?.loadResultsCount(filters: filters, completion: { [weak self] (count, _) in
            self?.delegate?.isLoading(loading: false)
            guard let count = count else {
                self?.handleResultsCountFailure()
                return
            }
            
            self?.handleResultsCountSuccess(count: count)
        })
    }

    func handleResultsCountSuccess(count: Int?) {
        if let count = count {
            delegate?.displayResultsCount(type.showFiltersText(count: count))
        }
    }

    func handleResultsCountFailure() {
        delegate?.displayResultsCount(type.showFiltersText(count: 0))
    }

    func loadEventsFilters() {
        dependencyProvider.networkProvider.eventsLoader.loadFilterSections { (result) in
            result.ifSuccess {
                self.configure(result.value?.data.options)
            }
        }
    }
    
    func loadCommunityFilters() {
        dependencyProvider.networkProvider.membersLoader.loadMemberFilterOptions { (result) in
            result.ifSuccess {
                self.configure(result.value)
            }
        }
    }
    
    private func setSelectedFiltersFromCache() {
        switch type {
        case .events, .community:
            if let key = type.filterCacheKey,
                let savedFilters: SectionedFilterParameters = UserDefaults.standard.decode(forKey: key),
                !(savedFilters.map { $0.value.isEmpty }).all(true) {
                delegate?.setRemoveAllEnabled(true)
                selectedFilterOptions = savedFilters
                for (section, _) in filterOptions {
                    setDataSources(in: section)
                }
            }
        default:
            return
        }
    }
    
}

// MARK: - FilterItemsDelegate
extension FiltersViewModel: FilterItemsDelegate {
    
    func itemsLoadingSuccessful() {
        delegate?.isLoading(loading: false)
        delegate?.dismissAction()
    }
    
    func itemsLoaded(withError error: Error?) {
        delegate?.isLoading(loading: false)
        delegate?.displayError(error)
    }
    
}
