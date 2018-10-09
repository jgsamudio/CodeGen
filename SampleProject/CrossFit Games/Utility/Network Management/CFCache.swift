//
//  CFCache.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/1/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

private class Container: NSDiscardableContent {

    let key: NSURLRequest
    let value: Decodable

    private let createDate = Date()

    init(key: NSURLRequest, value: Decodable) {
        self.key = key
        self.value = value
    }

    func beginContentAccess() -> Bool {
        return true
    }

    func discardContentIfPossible() {}

    func endContentAccess() {}

    func isContentDiscarded() -> Bool {
        return false
    }

}

/// Cache for objects downloaded from the API. Caching keys are URL requests and saved values are objects that have been downloaded and parsed
/// from the respective response.
final class CFCache: NSObject {

    /// Shared CrossFit cache.
    static let `default` = CFCache()

    private let cache = NSCache<NSURLRequest, Container>()

    private var keyCache = Set<NSURLRequest>()

    override init() {
        super.init()

        cache.delegate = self
    }

    /// All keys that currently have values associated with them.
    var keys: Set<URLRequest> {
        return Set(keyCache.map { $0 as URLRequest })
    }

    /// Contains the URL requests which need not be cached
    /// Therefore a fresh request will be sent everytime a request is needed
    /// for the specific URLs
    var needsRefresh: Set<URLRequest> = Set()

    /// Sets or returns a value for a given request as cache key.
    ///
    /// - Parameter request: Request used as caching key.
    subscript(request: URLRequest) -> Decodable? {
        get {
            return cache.object(forKey: request as NSURLRequest)?.value
        }
        set {
            guard let newValue = newValue else {
                keyCache.remove(request as NSURLRequest)
                cache.removeObject(forKey: request as NSURLRequest)
                return
            }
            cache.setObject(Container(key: request as NSURLRequest, value: newValue), forKey: request as NSURLRequest)
            keyCache.insert(request as NSURLRequest)
        }
    }

    /// Removes all content from the cache.
    func reset() {
        cache.removeAllObjects()
    }

    /// Resets all values where the given condition holds true.
    ///
    /// - Parameter condition: Condition on the URL request.
    func reset(where condition: (URLRequest) -> Bool) {
        // For all requests
        keyCache.map { $0 as URLRequest }
            // That meet the condition
            .filter(condition)
            .map { $0 as NSURLRequest }
            // Remove from cache
            .forEach {
                cache.removeObject(forKey: $0)
                keyCache.remove($0)
        }
    }

}

// MARK: - NSCacheDelegate
extension CFCache: NSCacheDelegate {

    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        if let obj = obj as? Container {
            keyCache.remove(obj.key)
        }
    }

}
