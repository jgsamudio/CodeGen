//
//  PublicVariableMarkGenerator.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 10/8/18.
//

import Foundation
import Source
import AST

class PublicVariableMarkGenerator: CodeGenerator {

    // MARK: - Public Properties
    
    static var name = "publicVariableMarkGenerator"

    let generatorConfig: GeneratorConfig

    // MARK: - Private Properties
    
    private var markAdded = false

    // MARK: - Initialization
    
    required init(generatorConfig: GeneratorConfig) {
        self.generatorConfig = generatorConfig
    }

    // MARK: - Public Functions
    
    func fileModifier<T: ASTNode>(node: T?,
                                  sourceLocation: SourceLocation,
                                  fileComponents: [String],
                                  visitedNodes: VisitedNodeCollection) -> FileModifier? {
        guard let insertions = generatorConfig.insertString, !markAdded,
            let variableNode = node as? DeclarationModifierProtocol, variableNode.modifiers.isPublic,
            let node = node, validNode(node, visitedNodes: visitedNodes, ignoredVisitors: [.function, .initializer]) else {
                return nil
        }
        markAdded = true

        let componentData = fileComponents.commentComponentData(startIndex: sourceLocation.index)
        let fileModifier = ProjectFileModifier(filePath: sourceLocation.identifier,
                                               startIndex: componentData.index,
                                               insertions: insertions.removeDoubleTopSpace(data: componentData).insertTabs())

        return foundInsertions(insertions,
                               fileComponents: fileComponents,
                               startIndex: componentData.index) ? nil : fileModifier
    }

}
