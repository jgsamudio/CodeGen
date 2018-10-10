//
//  Location.swift
//  TheWing
//
//  Created by The Wing Developers on 08/22/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
 Auto-Generated using ModelSynchro
 */

struct Location: Codable {
    
    // MARK: - Public Properties
    
    let address: Address? // let address: Address?
    let locationId: String // let _id: String
    let name: String
    let timeZoneId: String?
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case locationId = "_id"
        case name = "name"
        case timeZoneId = "timeZone"
    }

}
