//
//  FileModifier.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation

final class FileModifier {

    let filePath: String
    let startIndex: Int
    let insertions: [String]
    let deletions: [String]
    let replaceCurrentLine: Bool

    init(filePath: String,
         startIndex: Int,
         insertions: [String] = [],
         deletions: [String] = [],
         replaceCurrentLine: Bool = false) {
        self.filePath = filePath
        self.startIndex = startIndex
        self.insertions = insertions
        self.deletions = deletions
        self.replaceCurrentLine = replaceCurrentLine
    }

}
