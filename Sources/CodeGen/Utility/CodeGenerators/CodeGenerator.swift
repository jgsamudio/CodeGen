//
//  CodeGenerator.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation
import Source

protocol CodeGenerator {

    static var name: String { get }

    var generator: Generator { get }

    func fileModifier(sourceLocation: SourceLocation, fileComponents: [String]) -> FileModifier?
    
}
