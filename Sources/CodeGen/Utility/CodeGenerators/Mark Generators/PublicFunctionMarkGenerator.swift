//
//  PublicFunctionMarkGenerator.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 10/9/18.
//

import Foundation
import Source
import AST

class PublicFunctionMarkGenerator: CodeGenerator {

    static var name = "publicFunctionMarkGenerator"

    let generatorConfig: GeneratorConfig

    private var markAdded = false

    required init(generatorConfig: GeneratorConfig) {
        self.generatorConfig = generatorConfig
    }

    func fileModifier<T: ASTNode>(node: T?,
                                  sourceLocation: SourceLocation,
                                  fileComponents: [String],
                                  visitedNodes: [ASTNode]) -> FileModifier? {
        guard let insertions = generatorConfig.insertString,
            let functionNode = node as? FunctionDeclaration,
            functionNode.modifiers.isPublic,
            !visitedNodes.privateExtensionFunctionFound(with: functionNode),
            !markAdded else {
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
