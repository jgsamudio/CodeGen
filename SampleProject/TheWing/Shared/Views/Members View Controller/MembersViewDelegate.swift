//
//  MembersViewDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/7/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

protocol MembersViewDelegate: class {
    
    /// Notifies delegate that view should be refreshed.
    func refreshView()
    
    /// Notifies delegate that view is loading or not.
    ///
    /// - Parameter isLoading: True, if loading, false otherwise.
    func loading(_ isLoading: Bool)
    
    /// Sets the count of filter items in filter button.
    ///
    /// - Parameter count: Count of applied filters.
    func setFilterCount(_ count: Int)
    
    /// Notifies delegate that search action is taken by user.
    ///
    /// - Parameter searchText: Search text.
    func search(_ searchText: String?)

    /// Notifies delegate to display all members.
    func displayAllMembers()
    
    /// Notifies delegate immediately after view is reset.
    func didReset()
        
}
