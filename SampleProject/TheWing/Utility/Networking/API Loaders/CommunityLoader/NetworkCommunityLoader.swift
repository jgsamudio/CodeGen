//
//  NetworkCommunityLoader.swift
//  TheWing
//
//  Created by Ruchi Jain on 6/4/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Alamofire

final class NetworkCommunityLoader: Loader, CommunityLoader {

    // MARK: - Public Functions

    func loadMembers(parameters: CommunityParameters,
                     completion: @escaping (Result<ResponseData<MemberList>>) -> Void) {

    // MARK: - Public Properties
    
        var queryItems = [URLQueryItem(name: "pageSize", value: "\(parameters.pageSize)"),
                          URLQueryItem(name: "page", value: "\(parameters.page)")]

        if let term = parameters.term {
            queryItems.append(URLQueryItem(name: CommunityParameters.termLabel, value: term))
        }
        
        if let searchCriteria = parameters.searchCriteria {
            queryItems.append(URLQueryItem(name: CommunityParameters.searchCriteriaLabel, value: searchCriteria))
        }

        if let matchesOnly = parameters.matchesOnly {
            queryItems.append(queryItemForMatchesOnly(matchesOnly))
        }
        
        if let filters = parameters.filters {
            queryItems += filters.queryArrayItems()
        }
        
        let request = apiRequest(method: .get, endpoint: Endpoints.community, queryItems: queryItems)
        httpClient.perform(request: request, completion: completion)
    }
    
    func loadMemberFilterOptions(completion: @escaping (_ result: Result<[FilterSection]>) -> Void) {
        let request = apiRequest(method: .get, endpoint: Endpoints.memberFilters)
        httpClient.perform(request: request, completion: completion)
    }

    func loadMember(memberId: String, completion: @escaping (_ result: Result<User>) -> Void) {
        let request = apiRequest(method: .get, endpoint: Endpoints.member(memberId: memberId))
        httpClient.perform(request: request, completion: completion)
    }

    func loadMembersCount(term: String?,
                          filterParameters: FilterParameters,
                          searchCriteria: String?,
                          completion: @escaping (_ result: Result<ResponseData<MemberCount>>) -> Void) {
        var queryItems = filterParameters.queryArrayItems()

        if let term = term {
            queryItems.append(URLQueryItem(name: CommunityParameters.termLabel, value: term))
        }
        
        if let searchCriteria = searchCriteria {
            queryItems.append(URLQueryItem(name: CommunityParameters.searchCriteriaLabel, value: searchCriteria))
        }

        let request = apiRequest(method: .get, endpoint: Endpoints.memberCount, queryItems: queryItems)
        httpClient.perform(request: request, completion: completion)
    }
    
}

// MARK: - Private Functions
private extension NetworkCommunityLoader {
    
    func queryItemForMatchesOnly(_ matchesOnly: Bool) -> URLQueryItem {
        return URLQueryItem(name: CommunityParameters.matchesLabel, value: matchesOnly ? "true" : "false")
    }
    
}
