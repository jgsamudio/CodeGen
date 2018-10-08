//
//  InitializationMark.swift
//  AST
//
//  Created by Jonathan Samudio on 10/8/18.
//

import Foundation
import Source
import AST

class InitializationMark: CodeGenerator {

    static var name = "initializationMark"

    let generatorConfig: GeneratorConfig

    private var markAdded = false

    required init(generatorConfig: GeneratorConfig) {
        self.generatorConfig = generatorConfig
    }

    func fileModifier<T: ASTNode>(node: T?,
                                  sourceLocation: SourceLocation,
                                  fileComponents: [String]) -> FileModifier? {

        guard let insertions = generatorConfig.insertString, !markAdded else {
            return nil
        }

        markAdded = true
        if !insertStringFound(fileComponents: fileComponents, sourceLocation: sourceLocation) {
            return FileModifier(filePath: sourceLocation.identifier,
                                lineNumber: sourceLocation.line,
                                insertions: insertions.insertTabs())
        }
        return nil
    }

}
