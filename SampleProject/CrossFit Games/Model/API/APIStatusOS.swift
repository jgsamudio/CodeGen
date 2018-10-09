//
//  APIStatusOS.swift
//  CrossFit Games
//
//  Created by Malinka S on 1/16/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

struct APIStatusOS: Decodable {

    let iOS: APIStatus

    private enum CodingKeys: String, CodingKey {
        case iOS
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            iOS = try values.decode(APIStatus.self, forKey: .iOS)
        } catch {
            print(error)
            throw error
        }
    }
}
