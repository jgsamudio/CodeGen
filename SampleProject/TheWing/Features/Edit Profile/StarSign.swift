//
//  StarSign.swift
//  TheWing
//
//  Created by Jonathan Samudio on 7/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

enum StarSign: String {
    case none = ""
    case aries = "Aries"
    case taurus = "Taurus"
    case gemini = "Gemini"
    case cancer = "Cancer"
    case leo = "Leo"
    case virgo = "Virgo"
    case libra = "Libra"
    case scorpio = "Scorpio"
    case sagittarius = "Sagittarius"
    case capricorn = "Capricorn"
    case aquarius = "Aquarius"
    case pisces = "Pisces"
    
    // MARK: - Public Properties
    
    /// All star signs.
    static var all: [StarSign] = [.none,
                                  .aries,
                                  .taurus,
                                  .gemini,
                                  .cancer,
                                  .leo,
                                  .virgo,
                                  .libra,
                                  .scorpio,
                                  .sagittarius,
                                  .capricorn,
                                  .aquarius,
                                  .pisces]
    
    /// All star sign descriptions used for localization.
    static var descriptions = ["--",
                               "ARIES",
                               "TAURUS",
                               "GEMINI",
                               "CANCER",
                               "LEO",
                               "VIRGO",
                               "LIBRA",
                               "SCORPIO",
                               "SAGITTARIUS",
                               "CAPRICORN",
                               "AQUARIUS",
                               "PISCES"]
    
    /// Localized star sign description.
    var localizedDescription: String {
        var description = ""
        if let index = StarSign.all.index(of: self) {
            description = StarSign.descriptions[index]
        }
        
        return description.localized(comment: "Localized star sign").capitalized
    }
    
}
