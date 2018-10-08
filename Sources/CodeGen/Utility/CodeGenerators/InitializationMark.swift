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

        let componentData = fileComponents.commentComponentData(startIndex: sourceLocation.index)
        let fileModifier = FileModifier(filePath: sourceLocation.identifier,
                                        startIndex: componentData.index,
                                        insertions: insertions.removeDoubleTopSpace(data: componentData).insertTabs())

        return foundInsertions(insertions,
                               fileComponents: fileComponents,
                               startIndex: componentData.index) ? nil : fileModifier
    }

}
