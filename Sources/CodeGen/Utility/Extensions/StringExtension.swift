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
            try write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch let error {
            print("Error: " + error.localizedDescription)
        }
    }
    
}
