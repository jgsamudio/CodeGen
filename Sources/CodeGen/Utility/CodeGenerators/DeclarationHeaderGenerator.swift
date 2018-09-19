//
//  DeclarationHeaderGenerator.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation
import Source
import AST

struct DeclarationHeaderGenerator: CodeGenerator {

    static var name = "declarationHeader"

    let generator: Generator

    func fileModifier<T: Declaration>(declaration: T?,
                                      sourceLocation: SourceLocation,
                                      fileComponents: [String]) -> FileModifier? {
        guard var insertions = generator.insertString else {
            return nil
        }

        insertions.append("/// ===== Generator Name: \(DeclarationHeaderGenerator.name) =====")

        let fileModifier = FileModifier(filePath: sourceLocation.identifier,
                                        lineNumber: sourceLocation.line,
                                        insertions: insertions)

        let index = sourceLocation.line-1
        return (fileComponents[index-1] != insertions.last) ? fileModifier : nil
    }
    
}

struct PrivateExtensionMarkGenerator: CodeGenerator {

    static var name = "privateExtensionMark"

    let generator: Generator

    func fileModifier<T: Declaration>(declaration: T?,
                                      sourceLocation: SourceLocation,
                                      fileComponents: [String]) -> FileModifier? {
        guard let insertions = generator.insertString, let enumDeclaration = declaration as? ExtensionDeclaration, enumDeclaration.accessLevelModifier == .private else {
            return nil
        }

        let fileModifier = FileModifier(filePath: sourceLocation.identifier,
                                        lineNumber: sourceLocation.line,
                                        insertions: insertions)

        let index = sourceLocation.line-1
        let previousLine = fileComponents[index-1]
        return (previousLine != insertions.last) ? fileModifier : nil
    }
}
