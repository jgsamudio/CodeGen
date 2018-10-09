//
//  MovementStandardImage.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/3/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Movement standard image.
struct MovementStandardImage: Decodable {

    private enum CodingKeys: String, CodingKey {
        case title = "title_text"
        case imageUrl = "url"
    }

    // MARK: - Public Properties
    
    /// Title (/description) for the image.
    let title: String

    /// URL of the standards image.
    let imageUrl: URL?

}
