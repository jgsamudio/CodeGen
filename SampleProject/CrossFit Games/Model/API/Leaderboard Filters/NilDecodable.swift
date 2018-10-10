//
//  NilDecodable.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/22/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Object that doesn't contain any parameters and can be decoded from anything.
/// This object is decoded in case we don't find a matching filter data format.
struct NilDecodable: Decodable {
    
    // MARK: - Initialization
    
    init(from decoder: Decoder) throws {}
}
