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

    func fileModifier<T: ASTNode>(node: T?,
                                  sourceLocation: SourceLocation,
                                  fileComponents: [String]) -> FileModifier? {
        guard var insertions = generatorConfig.insertString,
            let extensionDeclaration = node as? ExtensionDeclaration,
            extensionDeclaration.accessLevelModifier == .private else {
                return nil
        }

        insertions.append("/// ===== Generator Name: \(PrivateExtensionMarkGenerator.name) =====")

        let fileModifier = FileModifier(filePath: sourceLocation.identifier,
                                        lineNumber: sourceLocation.line,
                                        insertions: insertions)

        let index = sourceLocation.line-1
        let previousLine = fileComponents[index-1]
        return (previousLine != insertions.last) ? fileModifier : nil
    }
}

class InitializationMark: CodeGenerator {

    static var name = "initializationMark"

    let generatorConfig: GeneratorConfig

    private var markAdded = false

    required init(generatorConfig: GeneratorConfig) {
        self.generatorConfig = generatorConfig
    }

    func fileModifier<T: ASTNode>(node: T?,
                                  sourceLocation: SourceLocation,
                                  fileComponents: [String]) -> FileModifier? {
        guard var insertions = generatorConfig.insertString, !markAdded else {
            return nil
        }

        insertions.append("/// ===== Generator Name: \(InitializationMark.name) =====")

        let index = sourceLocation.line-1
        let previousLine = fileComponents[index-1]

        if (previousLine != insertions.last) {
            markAdded = true
            return FileModifier(filePath: sourceLocation.identifier,
                                lineNumber: sourceLocation.line,
                                insertions: insertions)
        }
        return nil
    }
}
