//
//  Encodable+CrossFit.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/21/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

extension Encodable {

    /// JSON representation of `self` if parsing is possible.
    var json: [String: Any]? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            
            return try JSONSerialization.jsonObject(with: data,
                                                    options: .mutableContainers) as? [String: Any]
        } catch {
            return nil
        }
    }

}
