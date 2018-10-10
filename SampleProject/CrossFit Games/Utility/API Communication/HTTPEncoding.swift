//
//  HTTPEncoding.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 9/21/17.
//  Copyright © Prolific Interactive. All rights reserved.
//

import Alamofire
import Foundation

enum HTTPEncoding {

    /// Encoding as JSON dictionary.
    case json

    /// URL Encoding.
    case urlEncoding

    // MARK: - Public Properties
    
    var afEncoding: ParameterEncoding {
        switch self {
        case .json:
            return JSONEncoding.default
        case .urlEncoding:
            return URLEncoding.default
        }
    }

}
