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

    /// Name of the code generator.
    static var name: String { get }

    /// User's code gen config file.
    var generatorConfig: GeneratorConfig { get }

    /// Default initialization of the code generator.
    ///
    /// - Parameter generatorConfig: User's code gen config file.
    init(generatorConfig: GeneratorConfig)

    /// Returns an optional file modifier to update the user's code.
    ///
    /// - Parameters:
    ///   - node: Current ASTNode.
    ///   - sourceLocation: Location with in the source file.
    ///   - fileComponents: File lines components of the Swift file.
    /// - Returns: Optional file modifier with any changes.
    func fileModifier<T: ASTNode>(node: T?,
                                  sourceLocation: SourceLocation,
                                  fileComponents: [String]) -> FileModifier?
    
}

extension CodeGenerator {

    /// Determines if the insert string is found.
    ///
    /// - Parameters:
    ///   - fileComponents: File components of the swift file.
    ///   - sourceLocation: Location with in the source file.
    /// - Returns: Boolean if the insert string is found or not.
    func foundInsertions(_ insertString: [String]?, fileComponents: [String], startIndex: Int) -> Bool {
        return insertString?.isEqual(toBottomOf: Array(fileComponents[0..<startIndex])) ?? false
    }

}
