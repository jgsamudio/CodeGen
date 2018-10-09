//
//  RemoteConfig.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 2/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

/// In-app remote config structure, consisting of a list of promo items.
struct RemoteConfig {

    // MARK: - Public Properties
    
    /// Promo items to show in the app.
    let promoItems: [RemoteConfigPromoItem]

    // MARK: - Initialization
    
    init(remoteConfig: FirebaseRemoteConfig.RemoteConfig) {
        let rawValues: [(String?, String?, String?)] = [
            ("promo_link_1", remoteConfig.configValue(forKey: "promo_title_1").stringValue,
             remoteConfig.configValue(forKey: "promo_link_1").stringValue),
            ("promo_link_2", remoteConfig.configValue(forKey: "promo_title_2").stringValue,
             remoteConfig.configValue(forKey: "promo_link_2").stringValue)
        ]

        promoItems = rawValues.flatMap { (tuple) -> (String, String, URL)? in
            guard let key = tuple.0, let title = tuple.1, let link = tuple.2.flatMap(URL.init) else {
                return nil
            }

            guard !title.isEmpty else {
                return nil
            }

            guard !key.isEmpty else {
                return nil
            }

            return (key, title, link)
        }.map(RemoteConfigPromoItem.init)
    }

}
