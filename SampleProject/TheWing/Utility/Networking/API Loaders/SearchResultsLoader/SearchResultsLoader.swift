//
//  SearchResultsLoader.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/31/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Alamofire

protocol SearchResultsLoader {
    
    /// Queries API for companies.
    ///
    /// - Parameters:
    ///   - pageSize: Page size.
    ///   - page: Page.
    ///   - query: Search query.
    ///   - completion: Completion handler.
    func searchCompanies(pageSize: Int,
                         page: Int,
                         query: String,
                         completion: @escaping (_ result: Result<ResponseData<CompaniesList>>) -> Void)
    
    /// Queries API for positions.
    ///
    /// - Parameters:
    ///   - pageSize: Page size.
    ///   - page: Page.
    ///   - query: Search query.
    ///   - completion: Completion handler.
    func searchPositions(pageSize: Int,
                         page: Int,
                         query: String,
                         completion: @escaping (_ result: Result<ResponseData<PositionsList>>) -> Void)

    /// Queries API for asks.
    ///
    /// - Parameters:
    ///   - pageSize: Page size.
    ///   - page: Page.
    ///   - query: Search query.
    ///   - completion: Completion handler.
    func searchAsks(pageSize: Int,
                    page: Int,
                    query: String,
                    completion: @escaping (_ result: Result<ResponseData<AsksList>>) -> Void)
    
    /// Queries API for offers.
    ///
    /// - Parameters:
    ///   - pageSize: Page size.
    ///   - page: Page.
    ///   - query: Search query.
    ///   - completion: Completion handler.
    func searchOffers(pageSize: Int,
                      page: Int,
                      query: String,
                      completion: @escaping (_ result: Result<ResponseData<OffersList>>) -> Void)
    
    /// Queries API for interests.
    ///
    /// - Parameters:
    ///   - pageSize: Page size.
    ///   - page: Page.
    ///   - query: Search query.
    ///   - completion: Completion handler.
    func searchInterests(pageSize: Int,
                         page: Int,
                         query: String,
                         completion: @escaping (_ result: Result<ResponseData<InterestsList>>) -> Void)
    
    /// Get a list of neighborhoods for a typeaheard.
    ///
    /// - Parameters:
    ///   - typeahead: What has the user typed so far?
    ///   - completion: Completion handler.
    func searchNeighborhoods(with typeahead: String,
                             completion: @escaping (_ result: Result<ResponseData<NeighborhoodList>>) -> Void)
    
}
