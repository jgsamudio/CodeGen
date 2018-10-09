//
//  ApiInactiveError.swift
//  CrossFit Games
//
//  Created by Malinka S on 1/17/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

enum APIError: Decodable, Error {
    case inactive(title: String, message: String)
    case forceUpdate(title: String, message: String, storeLink: String)

    private enum CodingKeys: String, CodingKey {
        case iOS
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let iOS = try values.decode(APIStatus.self, forKey: .iOS)
            switch (iOS.apiActive) {
            case (_) where KillSwitchManager.isAppRequiredForceUpdate(with: iOS.minVersion):
                self = .forceUpdate(title: iOS.title ?? "",
                                    message: iOS.message ?? "",
                                    storeLink: iOS.storeLink)
            case (.some(false)):
                self = .inactive(title: iOS.title ?? "",
                                 message: iOS.message ?? "")
            default:
                throw DecodingError.typeMismatch(APIError.self,
                                                 DecodingError.Context(codingPath: decoder.codingPath,
                                                                       debugDescription: "Not an API error."))
            }
        } catch {
            print(error)
            throw error
        }
    }
}
