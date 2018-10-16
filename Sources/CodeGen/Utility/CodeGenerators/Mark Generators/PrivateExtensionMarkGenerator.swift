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

    // MARK: - Public Properties
    
    static var name = "privateExtensionMark"

    let generatorConfig: GeneratorConfig

    // MARK: - Public Functions
    
    func fileModifier<T: ASTNode>(node: T?,
                                  sourceLocation: SourceLocation,
                                  fileComponents: [String],
                                  visitedNodes: VisitedNodeCollection) -> FileModifier? {
        guard let insertions = generatorConfig.insertString,
            let extensionDeclaration = node as? ExtensionDeclaration,
            extensionDeclaration.accessLevelModifier == .private else {
                return nil
        }

        let fileModifier = ProjectFileModifier(filePath: sourceLocation.identifier,
                                               startIndex: sourceLocation.index,
                                               insertions: insertions)

        return foundInsertions(insertions,
                               fileComponents: fileComponents,
                               startIndex: sourceLocation.index) ? nil : fileModifier
    }
    
}
