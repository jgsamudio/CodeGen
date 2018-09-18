//
//  FileModifier.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation

final class FileModifier {

    let filePath: String
    let lineNumber: Int
    let insertions: [String]
    let deletions: [String]
    let replaceCurrentLine: Bool

    init(filePath: String,
         lineNumber: Int,
         insertions: [String] = [],
         deletions: [String] = [],
         replaceCurrentLine: Bool = false) {
        self.filePath = filePath
        self.lineNumber = lineNumber
        self.insertions = insertions
        self.deletions = deletions
        self.replaceCurrentLine = replaceCurrentLine
    }

    func indexToInsert(currentIndex: Int, fileComponents: [String]) -> Int? {
        for i in stride(from: currentIndex-1, to: 0, by: -1) {
            if fileComponents[i] == insertions.last {
                return nil
            } else {
                // add check for comments.
                return currentIndex
            }
        }
        return nil
    }

}
