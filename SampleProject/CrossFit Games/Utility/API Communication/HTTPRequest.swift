//
//  HTTPRequest.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/21/17.
//  Copyright © Prolific Interactive. All rights reserved.
//

import Alamofire
import Foundation

/// Network request that can be sent via instances of `HTTPClientProtocol`.
struct HTTPRequest {

    /// URL of the endpoint that receives the request.
    let url: URLConvertible

    /// Method of the request.
    let method: HTTPMethod

    /// Body that is sent with the request.
    let body: [String: Any]?

    /// Headers that are sent with the request.
    let headers: [String: String]?

    /// Encoding of the request.
    let encoding: ParameterEncoding

    /// Indicates whether a response can be cached.
    let allowCaching: Bool

    /// Indiactes whetehr to reload data ignoring local cached data
    let allowURLCaching: Bool

    /// URL request created from `self`.
    var urlRequest: URLRequest? {
        guard let url = try? url.asURL() else {
            return nil
        }

        let request = NSMutableURLRequest(url: url)

        request.httpMethod = method.rawValue
        if !allowURLCaching {
            request.cachePolicy = .reloadIgnoringLocalCacheData
        }
        headers?.forEach({ (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        })

        return try? encoding.encode(request as URLRequest, with: body)
    }

    /// Creates an HTTP request with the given attributes.
    ///
    /// - Parameters:
    ///   - url: URL of the request.
    ///   - method: HTTP method.
    ///   - body: Content that is sent in the body.
    ///   - headers: Headers of the request.
    ///   - encoding: Encoding of the request.
    init(url: URLConvertible,
         method: HTTPMethod = .get,
         body: [String: Any]? = nil,
         headers: [String: String]? = nil,
         encoding: HTTPEncoding = .json,
         allowCaching: Bool = false,
         allowURLCaching: Bool = true) {
        self.url = url
        self.method = method
        self.body = body
        self.headers = headers
        self.encoding = encoding.afEncoding
        self.allowCaching = allowCaching
        self.allowURLCaching = allowURLCaching
    }

    /// Creates an HTTP request with the given attributes.
    ///
    /// - Parameters:
    ///   - url: URL of the request.
    ///   - method: HTTP method.
    ///   - body: Encodable object whose json representation is sent as payload.
    ///   - headers: Headers of the request.
    ///   - encoding: Encoding of the request.
    init(url: URLConvertible,
         method: HTTPMethod,
         body: Encodable,
         headers: [String: String]? = nil,
         encoding: HTTPEncoding = .json,
         allowCaching: Bool = false,
         allowURLCaching: Bool = true) {
        self.init(url: url,
                  method: method,
                  body: body.json,
                  headers: headers,
                  encoding: encoding,
                  allowCaching: allowCaching,
                  allowURLCaching: allowURLCaching)
    }

}
