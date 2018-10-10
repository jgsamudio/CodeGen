//
//  StyleWeight.swift
//  CrossFit Games
//
//  Created by Malinka S on 10/9/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Denotes the weight attribute of the ying grid's style guide
/// Ex: Regular, Light, Medium, Bold
enum StyleWeight: Int {
    case w1 = 1
    case w2
    case w3
    case w4

    // MARK: - Public Properties
    
    var fontSuffix: String {
        switch self {
        case .w1:
            return "-Light"
        case .w3:
            return "-Medium"
        case .w4:
            return "-Bold"
        default:
            return ""
        }
    }
}
