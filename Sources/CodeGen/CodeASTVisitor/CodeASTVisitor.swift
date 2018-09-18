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

    init(fileComponents: [String], config: Configuration?) {
        self.fileComponents = fileComponents
        self.config = config

        codeGenerators = config?.enabledGenerators.compactMap {
            if $0.name == DeclarationHeaderGenerator.name {
                return DeclarationHeaderGenerator(generator: $0)
            }
            return nil
        } ?? []
    }

    func visit(_ declaration: ClassDeclaration) throws -> Bool {
        print(declaration.name)
        visited(.class, sourceLocation: declaration.sourceLocation)
        return true
    }

    func visit(_ declaration: StructDeclaration) throws -> Bool {
        print(declaration.name)
        visited(.struct, sourceLocation: declaration.sourceLocation)
        return true
    }

    func visit(_ declaration: EnumDeclaration) throws -> Bool {
        print(declaration.name)
        visited(.enum, sourceLocation: declaration.sourceLocation)
        return true
    }

    func visit(_ declaration: ProtocolDeclaration) throws -> Bool {
        print(declaration.name)
        visited(.protocol, sourceLocation: declaration.sourceLocation)
        return true
    }

    func visit(_ declaration: ExtensionDeclaration) throws -> Bool {
        return true
    }

}

private extension CodeASTVisitor {

    func visited(_ visitor: Visitor, sourceLocation: SourceLocation) {
        codeGenerators.filter { $0.generator.visitors?.contains(visitor) ?? false }.forEach {
            if let modifier = $0.fileModifier(sourceLocation: sourceLocation, fileComponents: fileComponents) {
                modifications.append(modifier)
            }
        }
    }

}
