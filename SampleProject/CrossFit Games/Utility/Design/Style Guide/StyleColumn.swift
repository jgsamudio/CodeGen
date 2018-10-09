//
//  StyleColumn.swift
//  StyleGuide
//
//  Created by Daniel Vancura on 9/21/17.
//  Copyright © 2017 Prolific Interactive LLC. All rights reserved.
//

import UIKit

/// Denotes the column attribute of the Ying grid's style guide
/// Basically the value represents the color
enum StyleColumn: Int {

    case c1 = 1
    case c2
    case c3
    case c4
    case c5
    case c6
    case c7

    var color: UIColor {
        switch self {
        case .c1:
            return .white
        case .c2:
            return UIColor(displayP3Red: 0, green: 87/255, blue: 184/255, alpha: 1)
        case .c3:
            return UIColor(displayP3Red: 186/255, green: 12/255, blue: 47/255, alpha: 1)
        case .c4:
            return .black
        case .c5:
            return UIColor(displayP3Red: 117/255, green: 120/255, blue: 123/255, alpha: 1)
        case .c6:
            return UIColor(displayP3Red: 227/255, green: 228/255, blue: 229/255, alpha: 1)
        case .c7:
            return UIColor(displayP3Red: 1, green: 54/255, blue: 94/255, alpha: 1)
        }
    }

}
