//
//  APIDivision.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 1/5/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

/// Divisions on the API.
enum APIDivision: Int {
    case men = 1
    case women
    case men45to49
    case women45to49
    case men50to54
    case women50to54
    case men55to59
    case women55to59
    case men60plus
    case women60plus
    case men40to44 = 12
    case women40to44
    case boys14to15
    case girls14to15
    case boys16to17
    case girls16to17
    case men35to39
    case women35to39

    /// Indicates that the given division is a "male division".
    var isMale: Bool {
        let maleDivisions: [APIDivision] = [
            .men, .men35to39, .men40to44, .men45to49, .men50to54, .men55to59, .men60plus,
            .boys14to15, .boys16to17
        ]

        return maleDivisions.contains(self)
    }

    /// Indicates that the given division is a "female division".
    var isFemale: Bool {
        return !isMale
    }
}
