//
//  APIStatus.swift
//  CrossFit Games
//
//  Created by Malinka S on 1/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct APIStatus: Decodable {
    /// Specifies if an API is inactive
    let apiActive: Bool?

    /// The title of the message to be displayed
    let title: String?

    /// Message to be displayed
    let message: String?

    /// URL to direct to the app store
    let storeLink: String

    /// Specifies the required app version to force the update
    let minVersion: String

    private enum CodingKeys: String, CodingKey {
        case apiActive
        case title
        case message
        case storeLink
        case minVersion
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            apiActive = try values.decodeIfPresent(Bool.self, forKey: .apiActive)
            title = try values.decodeIfPresent(String.self, forKey: .title)
            message = try values.decodeIfPresent(String.self, forKey: .message)
            storeLink = try values.decode(String.self, forKey: .storeLink)
            minVersion = try values.decode(String.self, forKey: .minVersion)
        } catch {
            print(error)
            throw error
        }
    }
}
