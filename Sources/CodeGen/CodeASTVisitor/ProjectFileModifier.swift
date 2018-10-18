//
//  ProjectFileModifier.swift
//  AST
//
//  Created by Jonathan Samudio on 10/18/18.
//

import Foundation

final class ProjectFileModifier: FileModifier {

    // MARK: - Public Properties

    var type = FileModifierType.fileModified

    let filePath: String
    let startIndex: Int
    let insertions: [String]
    let deletions: [String]
    let replaceCurrentLine: Bool

    // MARK: - Initialization

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
