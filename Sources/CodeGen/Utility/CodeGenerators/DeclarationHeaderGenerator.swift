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

    let generatorConfig: GeneratorConfig

    func fileModifier<T: Declaration>(declaration: T?,
                                      sourceLocation: SourceLocation,
                                      fileComponents: [String]) -> FileModifier? {
        guard var insertions = generatorConfig.insertString else {
            return nil
        }

        insertions.append("/// ===== Generator Name: \(DeclarationHeaderGenerator.name) =====")

        let fileModifier = FileModifier(filePath: sourceLocation.identifier,
                                        lineNumber: sourceLocation.line,
                                        insertions: insertions)

        let index = sourceLocation.line-1
        let previousLine = fileComponents[index-1]
        return (previousLine != insertions.last) ? fileModifier : nil
    }
    
}

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

struct DelegateExtensionMarkGenerator: CodeGenerator {

    static var name = "delegateExtensionMark"

    let generatorConfig: GeneratorConfig

    func fileModifier<T: Declaration>(declaration: T?,
                                      sourceLocation: SourceLocation,
                                      fileComponents: [String]) -> FileModifier? {
        guard let insertions = generatorConfig.insertString,
            let extensionDeclaration = declaration as? ExtensionDeclaration,
            let typeInheritanceList = extensionDeclaration.typeInheritanceClause?.typeInheritanceList,
            !typeInheritanceList.isEmpty else {
            return nil
        }

        let inheritanceString = typeInheritanceList.map { $0.names }.joined(separator: ", ")
        var mappedInsertions = insertions.map { String(format: $0, inheritanceString) }

        let fileModifier = FileModifier(filePath: sourceLocation.identifier,
                                        lineNumber: sourceLocation.line,
                                        insertions: mappedInsertions)

        let index = sourceLocation.line-1
        let previousLine = fileComponents[index-1]
        return (previousLine != insertions.last) ? fileModifier : nil
    }
}
