//
//  TopMatchesViewModel.swift
//  TheWing
//
//  Created by Luna An on 8/24/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

final class TopMatchesViewModel {
    
    // MARK: - Public Properties
    
    /// Top matches view delegate.
    weak var delegate: TopMatchesViewDelegate?
    
    /// Top matches member info.
    var topMatchesMemberInfo = [MemberInfo]() {
        didSet {
            delegate?.refresh()
        }
    }
    
    // MARK: - Private Properties
    
    private let dependencyProvider: DependencyProvider
    
    private var pageIndex = 1
    
    private var totalTopMatchesCount: Int?
    
    private var canFetch = true
    
    // MARK: - Initialization
    
    init(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
    
    // MARK: - Public Functions
    
    /// Loads top matched members.
    func loadTopMatches() {
        guard canFetch else {
            return
        }
        
        canFetch = false
        delegate?.isLoading(true)
        let parameters = CommunityParameters(page: pageIndex,
                                             pageSize: BusinessConstants.communityPageSize,
                                             filters: topMatchesFilters(),
                                             term: nil,
                                             searchCriteria: nil,
                                             matchesOnly: true)
        
        let memberLoader = dependencyProvider.networkProvider.membersLoader
        memberLoader.loadMembers(parameters: parameters) { [weak self] (result) in
                                    self?.delegate?.isLoading(false)
                                    result.ifSuccess {
                                        guard self?.pageIndex == result.value?.meta?.pagination.page ?? 0 else {
                                            return
                                        }
                                        self?.updateTotalCount(result.value?.meta?.pagination.total ?? 0)
                                        let members = result.value?.data.users ?? []
                                        self?.update(with: members)
                                    }
                                    result.ifFailure {
                                       self?.delegate?.displayError(result.error)
                                    }
        }
    }
    
}

// MARK: - Private Functions
private extension TopMatchesViewModel {
    
    func update(with newTopMatches: [Member]) {
        guard let totalTopMatchesCount = totalTopMatchesCount else {
            return
        }
        
        pageIndex += 1
        topMatchesMemberInfo += newTopMatches.map { MemberInfo(member: $0) }
        canFetch = topMatchesMemberInfo.count < totalTopMatchesCount
    }
   
    func updateTotalCount(_ count: Int) {
        totalTopMatchesCount = count
        let navigationTitle = String(format: "ALL_MATCHES".localized(comment: "All Matches"), "\(count)")
        delegate?.setNavigationTitle(navigationTitle)
    }
    
    func topMatchesFilters() -> FilterParameters? {
        guard let filters = UserDefaults.standard.communityFilters else {
            return nil
        }
        
        return FilterFormatter.formatFilter(filters)
    }

}

