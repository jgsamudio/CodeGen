//
//  DeclarationHeaderGenerator.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation
import Source

struct DeclarationHeaderGenerator: CodeGenerator {

    static var name = "declarationHeader"

    let generator: Generator

    func fileModifier(sourceLocation: SourceLocation, fileComponents: [String]) -> FileModifier? {
        guard let insertions = generator.insertString else {
            return nil
        }

        let fileModifier = FileModifier(filePath: sourceLocation.identifier,
                                        lineNumber: sourceLocation.line,
                                        insertions: insertions)

        let index = sourceLocation.line-1
        if fileComponents[index-1] != fileModifier.insertions.last {
            // add check for comments.
            return fileModifier
        }
        return nil
    }
}
