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

    // MARK: - Public Properties
    
    static var name = "protocolComformanceGenerator"

    var generatorConfig: GeneratorConfig

    // MARK: - Initialization
    
    init(generatorConfig: GeneratorConfig) {
        self.generatorConfig = generatorConfig
    }

    // MARK: - Public Functions
    
    func fileModifier<T: ASTNode>(node: T?, sourceLocation: SourceLocation,
                         fileComponents: [String],
                         visitedNodes: VisitedNodeCollection) -> FileModifier? {
        return nil
    }
    
}
