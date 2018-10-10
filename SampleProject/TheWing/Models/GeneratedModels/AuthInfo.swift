//
//  AuthInfo.swift
//  TheWing
//
//  Created by The Wing Developers on 03/30/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct AuthInfo: Codable {
    
    // MARK: - Public Properties
    
	let auth: Bool
	let token: String? // let token: String

	enum CodingKeys: String, CodingKey {
		case auth = "auth"
		case token = "token"
	}
}
