//
//  CreateAccountResponse.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/20/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

struct CreateAccountResponse: Codable {

    enum CodingKeys: String, CodingKey {
        case email = "email"
        case userId = "userid"
        case emailVerified = "email_verified"
    }

    let email: String
    let userId: String
    let emailVerified: Bool

}
