//
//  CommunityViewModel.swift
//  TheWing
//
//  Created by Jonathan Samudio on 3/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class CommunityViewModel: MembersProvider {
    
    // MARK: - Public Properties
    
    weak var delegate: MembersViewDelegate?
    
    weak var filterItemsDelegate: FilterItemsDelegate?
    
    var memberSearchCategory: MemberSearchCategory = .unfiltered
    
    var title = "ALL_MEMBERS_NO_COUNT".localized(comment: "All Members")
    
    var isLoading: Bool = false
    
    var filterType: FilterType {
        return .community
    }
        
    var memberInfo = [MemberInfo]()
    
    var matchesMemberInfo = [MemberInfo]()
    
    var topMatchesSectionHeaderTitle: String? {
        guard let count = totalTopMatchCount, count > 10 else {
            return nil
        }
        
        return CommunityLocalization.seeAllTopMatches(with: count)
    }
    
    var searchText: String?
    
    var totalMemberCount: Int?

    /// Determines if the load is the initial one.
    var isInitialLoad: Bool = true

    var isNoResultActive: Bool {
        return isInitialLoad ? false : memberInfo.isEmpty
    }

    var topMatchesCount: Int {
        return isInitialLoad ? 5 : matchesMemberInfo.count
    }
    
    // MARK: - Private Properties
    
    private let dependencyProvider: DependencyProvider
    
    private var lastPageLoadDate: Date?
    
    private var filters = SectionedFilterParameters() {
        didSet {
            reset()
        }
    }
    
    private var pageIndex = 1
    
    private var totalTopMatchCount: Int?
    
    private var canFetch = true
    
    private var isFilterEdited = false
    
    // MARK: - Initialization
    
    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
    
    // MARK: - Public Functions
    
    func loadMembers() {
        guard canFetch else {
            return
        }
        
        checkFiltersCount()
        canFetch = false
        delegate?.loading(true)
        
        let memberLoader = dependencyProvider.networkProvider.membersLoader
        let parameters = CommunityParameters(page: pageIndex,
                                             pageSize: BusinessConstants.communityPageSize,
                                             filters: FilterFormatter.formatFilter(UserDefaults.standard.communityFilters),
                                             term: searchText,
                                             searchCriteria: memberSearchCategory.queryParam,
                                             matchesOnly: nil)
        isLoading = true
        memberLoader.loadMembers(parameters: parameters) { [weak self] (result) in
            self?.isInitialLoad = false
            guard let strongSelf = self else {
                return
            }
            strongSelf.isLoading = false
            strongSelf.delegate?.loading(false)
            result.ifSuccess {
                guard strongSelf.pageIndex == result.value?.meta?.pagination.page ?? 0 else {
                    return
                }

                let members = result.value?.data.users ?? []
                if strongSelf.pageIndex == 1 {
                    strongSelf.lastPageLoadDate = Date()
                    strongSelf.updateTotalCount(result.value?.meta?.pagination.total ?? 0)
                    strongSelf.totalTopMatchCount = result.value?.data.topMatches?.total
                    strongSelf.update(with: members,
                                      topMatches: result.value?.data.topMatches?.users)
                } else {
                    strongSelf.update(with: members, topMatches: nil)
                }

                strongSelf.filterItemsDelegate?.itemsLoadingSuccessful()
            }
            result.ifFailure {
                strongSelf.filterItemsDelegate?.itemsLoaded(withError: result.error)
            }
        }
        
    }
    
    func filterMembers(category: MemberSearchCategory) {
        memberSearchCategory = category
        
        if memberSearchCategory == .unfiltered {
            searchText = nil
        }
        
        reset()
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
    
    func resetSearchAndFilter() {
        search(nil)
        editedFilters([:], count: 0)
    }
    
    /// Checks is the community page is out of date.
    func resyncCommunityPage() {
        if BusinessConstants.defaultRefreshInterval.hasElapsed(since: lastPageLoadDate) {
            reset()
        }
    }
    
    /// Resets the community view.
    func reset() {
        delegate?.didReset()
        UserDefaults.standard.communityFilters = filters
        pageIndex = 1
        canFetch = true
        isInitialLoad = true
        loadMembers()
    }
    
    /// Determines the member count with the given section.
    ///
    /// - Parameter section: Community section to check.
    /// - Returns: Member count in section.
    func memberCount(in section: CommunitySection) -> Int {
        switch (section, memberSearchCategory) {
        case (.topMatches, .unfiltered):
            return topMatchesCount > 0 ? 1 : 0
        case (.topMatches, .all), (.topMatches, .asks), (.topMatches, .offers):
            return 0
        default:
            return isInitialLoad ? 5 : memberCount
        }
    }
    
}

// MARK: - Private Functions
private extension CommunityViewModel {
    
    func update(with newMembers: [Member], topMatches: [Member]?) {
        if pageIndex == 1 {
            memberInfo.removeAll()
            matchesMemberInfo.removeAll()
        }
        
        let newMemberInfo = newMembers.map { return MemberInfo(member: $0) }
        
        if let topMatches = topMatches {
            matchesMemberInfo = topMatches.map { return MemberInfo(member: $0) }
        }
        
        pageIndex += 1
        memberInfo += newMemberInfo
        canFetch = memberInfo.count < totalMemberCount ?? 0
        delegate?.refreshView()
    }
    
    func updateTotalCount(_ count: Int) {
        totalMemberCount = count
        title = String(format: "ALL_MEMBERS".localized(comment: "All Members"), "\(count)")
    }
    
}

// MARK: - FiltersDelegate
extension CommunityViewModel: FiltersDelegate {
    
    func loadResultsCount(filters: FilterParameters, completion: @escaping (Int?, Error?) -> Void) {
        let loader = dependencyProvider.networkProvider.membersLoader
        loader.loadMembersCount(term: searchText,
                                filterParameters: filters,
                                searchCriteria: memberSearchCategory.queryParam) { (result) in
                                    result.ifSuccess {
                                        completion(result.value?.data.members, nil)
                                    }
                                    result.ifFailure {
                                        completion(nil, result.error)
                                    }
        }
    }
    
    func editedFilters(_ filters: SectionedFilterParameters, count: Int) {
        self.filters = filters
        isFilterEdited = true
        delegate?.setFilterCount(count)
        UserDefaults.standard.communityFilters = filters
    }
    
    func checkFiltersCount() {
        let count = FilterFormatter.formatFilter(UserDefaults.standard.communityFilters).count
        delegate?.setFilterCount(count)
    }
    
}
