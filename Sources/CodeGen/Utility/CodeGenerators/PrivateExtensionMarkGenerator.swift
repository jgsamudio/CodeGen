//
//  PrivateExtensionMarkGenerator.swift
//  AST
//
//  Created by Jonathan Samudio on 9/19/18.
//

import Foundation
import Source
import AST

struct PrivateExtensionMarkGenerator: CodeGenerator {

    static var name = "privateExtensionMark"

    let generatorConfig: GeneratorConfig

    func fileModifier<T: Declaration>(declaration: T?,
                                      sourceLocation: SourceLocation,
                                      fileComponents: [String]) -> FileModifier? {
        guard let insertions = generatorConfig.insertString,
            let extensionDeclaration = declaration as? ExtensionDeclaration,
            extensionDeclaration.accessLevelModifier == .private else {
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
