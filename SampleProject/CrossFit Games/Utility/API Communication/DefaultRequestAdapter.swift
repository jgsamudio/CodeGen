//
//  DefaultRequestAdaptor.swift
//  CrossFit Games
//
//  Created by Malinka S on 1/23/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation
import Alamofire

/// Request adapter to adapt the URL requests which are sent
final class DefaultRequestAdapter: RequestAdapter {

    // MARK: - Public Functions
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
    
    // MARK: - Public Properties
    
        var request = urlRequest

        guard let url = urlRequest.url, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return urlRequest
        }

        var items = urlComponents.queryItems ?? []
        items.append(URLQueryItem(name: "mobile-app-client", value: "1"))
        urlComponents.queryItems = items
        request.url = urlComponents.url ?? request.url

        return request
    }
    
}
