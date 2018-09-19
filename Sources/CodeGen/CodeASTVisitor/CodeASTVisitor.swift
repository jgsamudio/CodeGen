//
//  CodeASTVisitor.swift
//  AST
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation
import AST
import Source

final class CodeASTVisitor: ASTVisitor {

    var modifications = [FileModifier]()

    private let fileComponents: [String]
    private let config: Configuration?

    private let codeGenerators: [CodeGenerator]

    private static var availableGenerators: [CodeGenerator.Type] {
        return [DeclarationHeaderGenerator.self, PrivateExtensionMarkGenerator.self]
    }

    init(fileComponents: [String], config: Configuration?) {
        self.fileComponents = fileComponents
        self.config = config

        codeGenerators = config?.generators.compactMap {
            guard $0.enabled else {
                return nil
            }

            for generator in CodeASTVisitor.availableGenerators {
                if $0.name == generator.name {
                    return generator.init(generator: $0)
                }
            }
            return nil
        } ?? []
    }

    func visit(_ declaration: ClassDeclaration) throws -> Bool {
        visited(.class, sourceLocation: declaration.sourceLocation, declaration: declaration)
        return true
    }

    func visit(_ declaration: StructDeclaration) throws -> Bool {
        visited(.struct, sourceLocation: declaration.sourceLocation, declaration: declaration)
        return true
    }

    func visit(_ declaration: EnumDeclaration) throws -> Bool {
        visited(.enum, sourceLocation: declaration.sourceLocation, declaration: declaration)
        return true
    }

    func visit(_ declaration: ProtocolDeclaration) throws -> Bool {
        visited(.protocol, sourceLocation: declaration.sourceLocation, declaration: declaration)
        return true
    }

    func visit(_ declaration: ExtensionDeclaration) throws -> Bool {
        visited(.extension, sourceLocation: declaration.sourceLocation, declaration: declaration)
        return true
    }

}

private extension CodeASTVisitor {

    func visited<T: Declaration>(_ visitor: Visitor, sourceLocation: SourceLocation, declaration: T?) {
        codeGenerators.filter { $0.generator.visitors?.contains(visitor) ?? false }.forEach {
            if let modifier = $0.fileModifier(declaration: declaration,
                                              sourceLocation: sourceLocation,
                                              fileComponents: fileComponents) {
                modifications.append(modifier)
            }
        }
    }

}
