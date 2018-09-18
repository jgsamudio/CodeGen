//
//  DeclarationHeaderGenerator.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation
import Source

final class DeclarationHeaderGenerator: CodeGenerator {

    static var name = "declarationHeader"

    let generator: Generator

    init(generator: Generator) {
        self.generator = generator
    }

    func fileModifier(sourceLocation: SourceLocation, fileComponents: [String]) -> FileModifier? {
        guard let insertions = generator.insertString else {
            return nil
        }

        let fileModifier = FileModifier(filePath: sourceLocation.identifier,
                                        lineNumber: sourceLocation.line,
                                        insertions: insertions)

        let index = sourceLocation.line-1
        if Array(fileComponents[index-fileModifier.insertions.count..<index]) != fileModifier.insertions {
            // add check for comments.
            return fileModifier
        }
        return nil
    }
}
