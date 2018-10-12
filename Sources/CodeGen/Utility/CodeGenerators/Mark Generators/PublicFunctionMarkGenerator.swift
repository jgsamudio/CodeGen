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

    // MARK: - Public Properties
    
    static var name = "publicFunctionMarkGenerator"

    let generatorConfig: GeneratorConfig

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

        guard let insertions = generatorConfig.insertString,
            let functionNode = node as? FunctionDeclaration,
            functionNode.modifiers.isPublic,
            !visitedNodes.extensionFunctionFound(with: functionNode),
            !markAdded,
            validNode(functionNode,
                      visitedNodes: visitedNodes,
                      ignoredVisitors: [.extension],
                      visitedNodesValidator: visitedNodesValidator) else {
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

// MARK: - Private Functions
private extension PublicFunctionMarkGenerator {

    func visitedNodesValidator(_ node: ASTNode) -> Bool {
        if let extensionDeclaration = node as? ExtensionDeclaration {
            return extensionDeclaration.accessLevelModifier == .`private` ||
                extensionDeclaration.accessLevelModifier == .fileprivate
        }
        return true
    }
    
}
