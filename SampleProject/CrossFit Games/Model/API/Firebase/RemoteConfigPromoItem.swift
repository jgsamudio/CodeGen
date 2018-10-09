//
//  RemoteConfigPromoItem.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 2/15/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Item for the app's promo bar as delivered by the remote config.
struct RemoteConfigPromoItem {

    // Key
    let key: String

    /// Title of the item.
    let title: String

    /// Deeplink/URL for the item.
    let link: URL

    init(key: String, title: String, link: URL) {
        self.key = key
        self.title = title
        self.link = link
    }

}
