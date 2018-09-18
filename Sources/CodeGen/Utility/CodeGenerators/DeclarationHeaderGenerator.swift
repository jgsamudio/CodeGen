//
//  DeclarationHeaderGenerator.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation
import Source

final class DeclarationHeaderGenerator: CodeGenerator {

    var name = "declarationHeader"

    func fileModifier(sourceLocation: SourceLocation, fileComponents: [String]) -> FileModifier? {
        let fileModifier = FileModifier(filePath: sourceLocation.identifier,
                                        lineNumber: sourceLocation.line,
                                        insertions: ["// HELLO WORLD"])

        let index = sourceLocation.line-1
        if Array(fileComponents[index-fileModifier.insertions.count..<index]) != fileModifier.insertions {
            // add check for comments.
            return fileModifier
        }
        return nil
    }
}
