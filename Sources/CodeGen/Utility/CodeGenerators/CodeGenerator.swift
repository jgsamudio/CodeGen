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

    var generator: Generator { get }

    init(generator: Generator)

    func fileModifier<T: Declaration>(declaration: T?,
                                      sourceLocation: SourceLocation,
                                      fileComponents: [String]) -> FileModifier?
    
}
