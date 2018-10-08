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

        guard var insertions = generatorConfig.insertString, !markAdded else {
            return nil
        }

        markAdded = true
        let componentData = Array(fileComponents[0..<sourceLocation.index]).indexAboveComment(index: sourceLocation.index)
        if !componentData.insertTopSpace, insertions.first == "" {
            insertions.removeFirst()
        }

        if !insertStringFound(fileComponents: fileComponents, startIndex: componentData.index) {
            return FileModifier(filePath: sourceLocation.identifier,
                                startIndex: componentData.index,
                                insertions: insertions.insertTabs())
        }
        return nil
    }

}
