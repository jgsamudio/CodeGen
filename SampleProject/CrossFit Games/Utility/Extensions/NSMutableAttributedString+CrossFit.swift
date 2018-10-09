//
//  NSMutableAttributedString+CrossFit.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 11/1/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {

    /// Trims charactes from beginning and end of `self`.
    ///
    /// - Parameter charSet: Character set to trim characters from.
    func trimCharacters(inCharSet charSet: CharacterSet) {
        var range = (string as NSString).rangeOfCharacter(from: charSet)

        // Trim leading characters from character set.
        while range.length != 0 && range.location == 0 {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet)
        }

        // Trim trailing characters from character set.
        range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
        while range.length != 0 && NSMaxRange(range) == length {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
        }
    }

}
