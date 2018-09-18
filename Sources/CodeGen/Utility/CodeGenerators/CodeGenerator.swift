//
//  CodeGenerator.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation
import Source

protocol CodeGenerator {

    var name: String { get }

    func fileModifier(sourceLocation: SourceLocation, fileComponents: [String]) -> FileModifier?
}
