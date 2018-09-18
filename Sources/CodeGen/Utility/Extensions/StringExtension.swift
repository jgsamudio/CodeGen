//
//  StringExtension.swift
//  AST
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation

extension String {

    func writeToFile(directory: String) {
        guard let fileURL = URL(string: directory) else {
            print("Error: Not a valid url: " + directory)
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
