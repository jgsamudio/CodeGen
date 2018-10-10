//
//  DeepLinkGenerator.swift
//  TheWing
//
//  Created by Luna An on 5/8/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Branch

final class DeepLinkGenerator {
    
    // MARK: - Public Functions
    
    /// Generates deep link URL for a shareable object via deep links.
    ///
    /// - Parameters:
    ///   - objectToShare: The object to share.
    ///   - completion: The completion handler.
    ///   - failure: The failure indicator.
    static func generateDeeplinkURL(for objectToShare: DeepLinkShareable,
                                    completion: @escaping (String) -> Void,
                                    failure: @escaping () -> Void) {
    
    // MARK: - Public Properties
    
        let deeplinkUniversalObject = createDeepLinkObject(for: objectToShare)
        do {
            let linkProperties = try createDeepLinkProperties(objectToShare)
            getDeepLinkURL(from: deeplinkUniversalObject,
                           linkProperties: linkProperties,
                           completion: completion,
                           failure: failure)
        } catch {
            failure()
        }
    }
    
}

// MARK: - Private Functions
private extension DeepLinkGenerator {
    
    /// The Branch Universal Object encapsulates the information to share.
    static func createDeepLinkObject(for objectToShare: DeepLinkShareable) -> BranchUniversalObject {
        let branchUniversalObject = BranchUniversalObject(canonicalIdentifier: objectToShare.objectId)
        branchUniversalObject.canonicalUrl = objectToShare.canonicalUrl
        branchUniversalObject.title = objectToShare.title
        branchUniversalObject.contentDescription = objectToShare.contentDescription
        let additionalInformation = NSMutableDictionary(dictionary: objectToShare.additionalInformation)
        branchUniversalObject.contentMetadata.customMetadata = additionalInformation
        
        return branchUniversalObject
    }
    
    /// Used to generated the analytical properties for the deep link.
    static func createDeepLinkProperties(_ objectToShare: DeepLinkShareable) throws -> BranchLinkProperties {
        let linkProperties = BranchLinkProperties()
        
        guard let fallbackUrlString = objectToShare.fallbackURLString
            .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let fallbackUrl = URL(string: fallbackUrlString) else {
                assert(false, "Cannot generate fallback URL for \(objectToShare.fallbackURLString)")
                return linkProperties
        }
        
        linkProperties.addControlParam("$fallback_url", withValue: fallbackUrl.absoluteString)
        linkProperties.addControlParam("$uri_redirect_mode", withValue: "1")
        return linkProperties
    }
    
    /// Creates a deep link withint the app.
    static func getDeepLinkURL(from deeplinkUniversalObject: BranchUniversalObject,
                               linkProperties: BranchLinkProperties,
                               completion: @escaping (String) -> Void,
                               failure: @escaping () -> Void) {
        deeplinkUniversalObject.getShortUrl(with: linkProperties) { (url, error) in
            guard let url = url, error == nil else {
                return failure()
            }
            completion(url)
        }
    }
    
}
