//
//  Regex.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 10/8/18.
//

import Foundation

/// Defines a class to handle regular expressions
final class Regex {

    /// The regular expression
    let expression: NSRegularExpression

    /// The pattern represented by the regular expression
    let pattern: String

    /// Creates an instance of Regex
    ///
    /// - Parameter pattern: The regular expression pattern
    init(_ pattern: String) {
        self.pattern = pattern
        self.expression = try! NSRegularExpression(pattern: pattern, options: [])
    }

    /// Returns true if the regular expression matches at least one substring of the input
    ///
    /// - Parameter input: The input string to test against the regex
    /// - Returns: True if the regex was able to find at least one match in the input
    func hasMatch(input: String) -> Bool {
        let matches = expression.matches(in: input,
                                         options: [],
                                         range:NSMakeRange(0, input.count))
        return matches.count > 0
    }

    /// Returns a Regex instance that matches C-style and inline comments
    ///
    /// - Returns: A Regex instance that can match C-style and inline comments
    static func commentRegex() -> Regex {
        return Regex(Constants.Regex.comment)
    }

}
