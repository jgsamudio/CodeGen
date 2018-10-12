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

    static var name = "publicVariableMarkGenerator"

    let generatorConfig: GeneratorConfig

    private var markAdded = false

    required init(generatorConfig: GeneratorConfig) {
        self.generatorConfig = generatorConfig
    }

    func fileModifier<T: ASTNode>(node: T?,
                                  sourceLocation: SourceLocation,
                                  fileComponents: [String],
                                  visitedNodes: VisitedNodeCollection) -> FileModifier? {
        guard let insertions = generatorConfig.insertString, !markAdded,
            let variableNode = node as? DeclarationModifierProtocol, variableNode.modifiers.isPublic,
            !visitedNodes.functionVariableDeclarationFound(with: variableNode) else {
                return nil
        }
        markAdded = true

        let componentData = fileComponents.commentComponentData(startIndex: sourceLocation.index)
        let fileModifier = FileModifier(filePath: sourceLocation.identifier,
                                        startIndex: componentData.index,
                                        insertions: insertions.removeDoubleTopSpace(data: componentData).insertTabs())

        return foundInsertions(insertions,
                               fileComponents: fileComponents,
                               startIndex: componentData.index) ? nil : fileModifier
    }

}
