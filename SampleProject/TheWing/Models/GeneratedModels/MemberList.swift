//
//  MemberList.swift
//  TheWing
//
//  Created by The Wing Developers on 07/09/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
 Auto-Generated using ModelSynchro
 */

struct MemberList: Codable {
    
    // MARK: - Public Properties
    
    let users: [Member]
    let topMatches: TopMatches?
    
    enum CodingKeys: String, CodingKey {
        case users = "users"
        case topMatches = "topMatches"
    }

}
