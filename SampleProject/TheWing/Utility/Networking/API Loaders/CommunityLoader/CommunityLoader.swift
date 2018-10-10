//
//  CommunityLoader.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Alamofire

protocol CommunityLoader {
    
    /// Loads member list from API given page, page size, and filter parameters.
    ///
    /// - Parameters:
    ///   - parameters: Query parameters for community.
    ///   - completion: Completion handler with member list.
    func loadMembers(parameters: CommunityParameters,
                     completion: @escaping (_ result: Result<ResponseData<MemberList>>) -> Void)

    /// Loads filter options.
    ///
    /// - Parameter completion: Completion handler with array of filter sections.
    func loadMemberFilterOptions(completion: @escaping (_ result: Result<[FilterSection]>) -> Void)

    /// Loads a member profile.
    ///
    /// - Parameters:
    ///   - memberId: Id of the member.
    ///   - completion: Completion block of the network call.
    func loadMember(memberId: String, completion: @escaping (_ result: Result<User>) -> Void)

    /// Loads the members count.
    ///
    /// - Parameters:
    ///   - term: Search term.
    ///   - filterParameters: Filter parameters.
    ///   - searchCriteria: Criteria on which search term applies.
    ///   - completion: Completion handler with member count.
    func loadMembersCount(term: String?,
                          filterParameters: FilterParameters,
                          searchCriteria: String?,
                          completion: @escaping (_ result: Result<ResponseData<MemberCount>>) -> Void)
    
}
