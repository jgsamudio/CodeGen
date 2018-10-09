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

    func fileModifier<T: ASTNode>(node: T?,
                                  sourceLocation: SourceLocation,
                                  fileComponents: [String],
                                  visitedNodes: VisitedNodeCollection) -> FileModifier? {
        guard let insertions = generatorConfig.insertString else {
            return nil
        }

        let fileModifier = FileModifier(filePath: sourceLocation.identifier,
                                        startIndex: sourceLocation.index,
                                        insertions: insertions)

        return foundInsertions(insertions,
                               fileComponents: fileComponents,
                               startIndex: sourceLocation.index) ? nil : fileModifier
    }
    
}
