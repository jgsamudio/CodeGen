//
//  AttendeesViewModel.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class AttendeesViewModel: MembersProvider {

    // MARK: - Public Properties

    weak var delegate: MembersViewDelegate?
    
    weak var filterItemsDelegate: FilterItemsDelegate?
    
    var filterType: FilterType {
        return .attendees(eventId: eventId)
    }
    
    var title: String
    
    var memberInfo = [MemberInfo]()
    
    var searchText: String?
    
    var isNoResultActive: Bool {
        return memberInfo.count == 0
    }
    
    var isLoading: Bool = false
    
    var memberSearchCategory: MemberSearchCategory = .unfiltered

    var totalMemberCount: Int?
    
    // MARK: - Private Properties

    private let dependencyProvider: DependencyProvider
    
    private let eventId: String
    
    private var pageIndex = 1
    
    private var canFetch = true

    private var filters = SectionedFilterParameters() {
        didSet {
            reset()
        }
    }
    
    // MARK: - Initialization

    init(eventId: String, title: String, dependencyProvider: DependencyProvider) {
        self.title = title
        self.eventId = eventId
        self.dependencyProvider = dependencyProvider
    }

    // MARK: - Public Functions
    
    func loadMembers() {
        guard canFetch else {
            return
        }

        canFetch = false
        isLoading = true
        delegate?.loading(true)
        
        let parameters = CommunityParameters(page: pageIndex,
                                             pageSize: BusinessConstants.communityPageSize,
                                             filters: attendeesFilters(),
                                             term: searchText,
                                             searchCriteria: memberSearchCategory.queryParam,
                                             matchesOnly: nil)
        
        let eventsLoader = dependencyProvider.networkProvider.eventsLoader
        eventsLoader.loadEventAttendees(eventId: eventId,
                                        parameters: parameters) { [weak self] (result) in
                                            guard let strongSelf = self else {
                                                return
                                            }
                                            strongSelf.isLoading = false
                                            strongSelf.delegate?.loading(false)
                                            result.ifSuccess {
                                                guard strongSelf.pageIndex == result.value?.meta?.pagination.page ?? 0 else {
                                                    return
                                                }
                                                
                                                strongSelf.totalMemberCount = result.value?.meta?.pagination.total ?? 0
                                                let members = result.value?.data.attendees ?? []
                                                strongSelf.update(with: members)
                                                strongSelf.filterItemsDelegate?.itemsLoadingSuccessful()
                                            }
                                            result.ifFailure {
                                                strongSelf.filterItemsDelegate?.itemsLoaded(withError: result.error)
                                            }
        }
    }
    
    func loadResultsCount(filters: FilterParameters, completion: @escaping (Int?, Error?) -> Void) {
        let loader = dependencyProvider.networkProvider.eventsLoader
        loader.loadEventAttendeesCount(eventId: eventId,
                                       term: searchText,
                                       filterParameters: filters,
                                       searchCriteria: memberSearchCategory.queryParam) { (result) in
            result.ifSuccess {
                completion(result.value?.data.attendees, nil)
            }
            result.ifFailure {
                completion(nil, result.error)
            }
        }
    }
    
    func editedFilters(_ filters: SectionedFilterParameters, count: Int) {
        self.filters = filters
        delegate?.setFilterCount(count)
    }
    
    func search(_ searchText: String?) {
        guard searchText?.whitespaceTrimmedAndNilIfEmpty != self.searchText?.whitespaceTrimmedAndNilIfEmpty else {
            return
        }
        
        if let text = searchText, !text.isEmpty {
            delegate?.search(text)
        } else {
            delegate?.displayAllMembers()
        }
    }
    
    func filterMembers(category: MemberSearchCategory) {
        memberSearchCategory = category
        
        if memberSearchCategory == .unfiltered {
            searchText = nil
        }
        
        reset()
    }
    
    func resetSearchAndFilter() {
        search(nil)
        editedFilters([:], count: 0)
    }
    
    func reset() {
        delegate?.didReset()
        memberInfo = []
        pageIndex = 1
        canFetch = true
        isLoading = true
        delegate?.refreshView()
        loadMembers()
    }
    
}

// MARK: - Private Functions
private extension AttendeesViewModel {
    
    func update(with newMembers: [Member]) {
        if pageIndex == 1 {
            memberInfo.removeAll()
        }
        
        pageIndex += 1
        memberInfo += newMembers.map { MemberInfo(member: $0) }
        canFetch = memberInfo.count < totalMemberCount ?? 0
        delegate?.refreshView()
    }
    
    func attendeesFilters() -> FilterParameters? {
        var filterParameters = FilterParameters()
        filters.forEach {
            if !$0.value.isEmpty {
                filterParameters[$0.key.lowercased()] = $0.value.map { $0.filterId }
            }
        }
        
        return filterParameters.isEmpty ? nil : filterParameters
    }
    
}
