//
//  SponsorImage.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/24/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Represnts the image attributes of a sponsor
struct SponsorImage: Codable {

    /// Main image URL
    let imageURL: String

    private enum CodingKeys: String, CodingKey {
        case imageURL = "url"
    }
}
