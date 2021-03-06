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

    // MARK: - Public Properties
    
    static var name = "declarationHeader"

    let generatorConfig: GeneratorConfig

    // MARK: - Public Functions
    
    func fileModifier<T: ASTNode>(node: T?,
                                  sourceLocation: SourceLocation,
                                  fileComponents: [String],
                                  visitedNodes: VisitedNodeCollection) -> FileModifier? {
        guard let insertions = generatorConfig.insertString else {
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
