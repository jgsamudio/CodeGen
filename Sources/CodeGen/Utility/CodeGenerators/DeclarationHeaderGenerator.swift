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
