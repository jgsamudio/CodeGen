//
//  ProtocolComformanceGenerator.swift
//  AST
//
//  Created by Jonathan Samudio on 10/16/18.
//

import Foundation
import Source
import AST

final class ProtocolComformanceGenerator: CodeGenerator {

    static var name = "protocolComformanceGenerator"

    var generatorConfig: GeneratorConfig

    init(generatorConfig: GeneratorConfig) {
        self.generatorConfig = generatorConfig
    }

    func fileModifier<T: ASTNode>(node: T?, sourceLocation: SourceLocation,
                         fileComponents: [String],
                         visitedNodes: VisitedNodeCollection) -> FileModifier? {
        return nil
    }
    
}
