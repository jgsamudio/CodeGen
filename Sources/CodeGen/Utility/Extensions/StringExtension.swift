//
//  StringExtension.swift
//  AST
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation

extension String {

    func writeToFile(directory: String) {
        let urlString = "file://\(directory.replacingOccurrences(of: " ", with: "%20"))"
        guard let fileURL = URL(string: urlString) else {
            return
        }

        do {
            try write(to: fileURL, atomically: true, encoding: .utf8)
        }
        catch let error {
            print("Error: " + error.localizedDescription)
        }
    }

    /// Returns true if the string containing Swift code is a comment.
    ///
    /// - Returns: True if the string containing Swift code is a comment.
    func isComment() -> Bool {
        return Regex.commentRegex().hasMatch(input: self) ||
            self.components(separatedBy: " ").contains("*") ||
            self.components(separatedBy: " ").contains("-")
    }
    
}
