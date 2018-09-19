//
//  DelegateExtensionMarkGenerator.swift
//  AST
//
//  Created by Jonathan Samudio on 9/19/18.
//

import Foundation
import Source
import AST

struct DelegateExtensionMarkGenerator: CodeGenerator {

    static var name = "delegateExtensionMark"

    let generatorConfig: GeneratorConfig

    func fileModifier<T: ASTNode>(node: T?,
                                  sourceLocation: SourceLocation,
                                  fileComponents: [String]) -> FileModifier? {
        guard var insertions = generatorConfig.insertString,
            let extensionDeclaration = node as? ExtensionDeclaration,
            let typeInheritanceList = extensionDeclaration.typeInheritanceClause?.typeInheritanceList,
            !typeInheritanceList.isEmpty else {
                return nil
        }

        insertions.append("/// ===== Generator Name: \(DelegateExtensionMarkGenerator.name) =====")

        let inheritanceString = (typeInheritanceList.compactMap { $0.names.first?.name.description }).joined(separator: ", ")
        let mappedInsertions = insertions.map { String(format: $0, inheritanceString) }

        let fileModifier = FileModifier(filePath: sourceLocation.identifier,
                                        lineNumber: sourceLocation.line,
                                        insertions: mappedInsertions)

        let index = sourceLocation.line-1
        let previousLine = fileComponents[index-1]
        return (previousLine != mappedInsertions.last) ? fileModifier : nil
    }
}