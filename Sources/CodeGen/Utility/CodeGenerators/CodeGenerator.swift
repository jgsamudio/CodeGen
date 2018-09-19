//
//  CodeGenerator.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation
import Source
import AST

protocol CodeGenerator {

    static var name: String { get }

    var generatorConfig: GeneratorConfig { get }

    init(generatorConfig: GeneratorConfig)

    func fileModifier<T: ASTNode>(node: T?,
                                  sourceLocation: SourceLocation,
                                  fileComponents: [String]) -> FileModifier?
    
}
