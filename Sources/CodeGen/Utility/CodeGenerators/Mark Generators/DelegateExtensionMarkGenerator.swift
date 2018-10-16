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

    // MARK: - Public Properties
    
    static var name = "delegateExtensionMark"

    let generatorConfig: GeneratorConfig

    // MARK: - Public Functions
    
    func fileModifier<T: ASTNode>(node: T?,
                                  sourceLocation: SourceLocation,
                                  fileComponents: [String],
                                  visitedNodes: VisitedNodeCollection) -> FileModifier? {
        guard let insertions = generatorConfig.insertString,
            let extensionDeclaration = node as? ExtensionDeclaration,
            let typeInheritanceList = extensionDeclaration.typeInheritanceClause?.typeInheritanceList,
            !typeInheritanceList.isEmpty else {
                return nil
        }

        let inheritanceString = (typeInheritanceList.compactMap { $0.names.first?.name.description }).joined(separator: ", ")
        let mappedInsertions = insertions.map { String(format: $0, inheritanceString) }

        let fileModifier = ProjectFileModifier(filePath: sourceLocation.identifier,
                                               startIndex: sourceLocation.index,
                                               insertions: mappedInsertions)

        return foundInsertions(mappedInsertions,
                               fileComponents: fileComponents,
                               startIndex: sourceLocation.index) ? nil : fileModifier
    }

}
