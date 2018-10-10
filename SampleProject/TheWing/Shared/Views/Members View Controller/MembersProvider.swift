//
//  MembersProvider.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/7/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol MembersProvider: FiltersDelegate {
    
    /// Title of the view.
    var title: String { get set }
    
    /// Binding delegate.
    var delegate: MembersViewDelegate? { get set }
    
    /// Collection of member information.
    var memberInfo: [MemberInfo] { get set }
    
    /// Total count of members.
    var totalMemberCount: Int? { get set }
    
    /// Count of members.
    var memberCount: Int { get }
    
    // Are you currently loading a network request?
    var isLoading: Bool { get }
    
    // Both "isLoading" and 0 member count.
    var shouldShowShimmerState: Bool { get }
    
    /// User entered search text.
    var searchText: String? { get set }
    
    /// Filter type.
    var filterType: FilterType { get }
    
    /// Flag to determine if no result view is currently active.
    var isNoResultActive: Bool { get }
    
    /// Member search category.
    var memberSearchCategory: MemberSearchCategory { get set }
    
    /// Notifies provider to load members.
    func loadMembers()
    
    /// Filters members by member search category.
    ///
    /// - Parameter category: Member search category.
    func filterMembers(category: MemberSearchCategory)
    
    /// Called to indicate search action is taken by user.
    ///
    /// - Parameter searchText: Search text entered.
    func search(_ searchText: String?)
    
    /// Called to reset pre entered/defined search and filer.
    func resetSearchAndFilter()
    
    /// Called when filters are reset or search term was set.
    func reset()
        
}

extension MembersProvider {
    
    // MARK: - Public Properties
    
    var memberCount: Int {
        if shouldShowShimmerState {
            return 10
        }
        return memberInfo.count == 0 ? 1 : memberInfo.count
    }
    
    var shouldShowShimmerState: Bool {
        return isLoading && memberInfo.count == 0
    }
    
}
