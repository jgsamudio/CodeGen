//
//  NetworkSearchResultsLoader.swift
//  TheWing
//
//  Created by Ruchi Jain on 4/12/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Alamofire

final class NetworkSearchResultsLoader: Loader, SearchResultsLoader {
    
    // MARK: - Public Functions

    func searchCompanies(pageSize: Int,
                         page: Int,
                         query: String,
                         completion: @escaping (_ result: Result<ResponseData<CompaniesList>>) -> Void) {
    
    // MARK: - Public Properties
    
        let queryItems = [URLQueryItem(name: "pageSize", value: String(pageSize)),
                          URLQueryItem(name: "page", value: String(page)),
                          URLQueryItem(name: "term", value: query)]
        let request = apiRequest(method: .get, endpoint: Endpoints.companies, queryItems: queryItems)
        httpClient.perform(request: request, completion: completion)
    }
    
    func searchPositions(pageSize: Int,
                         page: Int,
                         query: String,
                         completion: @escaping (_ result: Result<ResponseData<PositionsList>>) -> Void) {
        let queryItems = [URLQueryItem(name: "pageSize", value: String(pageSize)),
                          URLQueryItem(name: "page", value: String(page)),
                          URLQueryItem(name: "term", value: query)]
        let request = apiRequest(method: .get, endpoint: Endpoints.positions, queryItems: queryItems)
        httpClient.perform(request: request, completion: completion)
    }
    
    func searchAsks(pageSize: Int,
                    page: Int,
                    query: String,
                    completion: @escaping (_ result: Result<ResponseData<AsksList>>) -> Void) {
        let queryItems = [URLQueryItem(name: "pageSize", value: String(pageSize)),
                          URLQueryItem(name: "page", value: String(page)),
                          URLQueryItem(name: "term", value: query)]
        let request = apiRequest(method: .get, endpoint: Endpoints.asks, queryItems: queryItems)
        httpClient.perform(request: request, completion: completion)
    }
    
    func searchOffers(pageSize: Int,
                      page: Int,
                      query: String,
                      completion: @escaping (_ result: Result<ResponseData<OffersList>>) -> Void) {
        let queryItems = [URLQueryItem(name: "pageSize", value: String(pageSize)),
                          URLQueryItem(name: "page", value: String(page)),
                          URLQueryItem(name: "term", value: query)]
        let request = apiRequest(method: .get, endpoint: Endpoints.offers, queryItems: queryItems)
        httpClient.perform(request: request, completion: completion)
    }
    
    func searchInterests(pageSize: Int,
                         page: Int,
                         query: String,
                         completion: @escaping (_ result: Result<ResponseData<InterestsList>>) -> Void) {
        let queryItems = [URLQueryItem(name: "pageSize", value: String(pageSize)),
                          URLQueryItem(name: "page", value: String(page)),
                          URLQueryItem(name: "term", value: query)]
        let request = apiRequest(method: .get, endpoint: Endpoints.interests, queryItems: queryItems)
        httpClient.perform(request: request, completion: completion)
    }
    
    func searchNeighborhoods(with typeahead: String,
                             completion: @escaping (_ result: Result<ResponseData<NeighborhoodList>>) -> Void) {
        let queryItems = [URLQueryItem(name: "query", value: typeahead)]
        let request = apiRequest(method: .get, endpoint: Endpoints.neighborhoods, queryItems: queryItems)
        httpClient.perform(request: request, completion: completion)
    }

}
