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

    private var visitedNodes: [ASTNode]

    private let fileComponents: [String]
    private let config: Configuration?
    private let codeGenerators: [CodeGenerator]

    private static var availableGenerators: [CodeGenerator.Type] {
        return [DeclarationHeaderGenerator.self,
                PrivateExtensionMarkGenerator.self,
                DelegateExtensionMarkGenerator.self,
                InitializationMarkGenerator.self,
                PublicVariableMarkGenerator.self,
                PrivateVariableMarkGenerator.self,
                PublicFunctionMarkGenerator.self]
    }

    init(fileComponents: [String], config: Configuration?) {
        self.fileComponents = fileComponents
        self.config = config
        self.visitedNodes = []

        codeGenerators = config?.generators.compactMap {
            if $0.enabled {
                for generator in CodeASTVisitor.availableGenerators {
                    if $0.name == generator.name {
                        return generator.init(generatorConfig: $0)
                    }
                }
            }
            return nil
        } ?? []
    }

    func visit(_ declaration: ClassDeclaration) throws -> Bool {
        visited(.class, sourceLocation: declaration.sourceLocation, node: declaration)
        return true
    }

    func visit(_ declaration: StructDeclaration) throws -> Bool {
        visited(.struct, sourceLocation: declaration.sourceLocation, node: declaration)
        return true
    }

    func visit(_ declaration: EnumDeclaration) throws -> Bool {
        visited(.enum, sourceLocation: declaration.sourceLocation, node: declaration)
        return true
    }

    func visit(_ declaration: ProtocolDeclaration) throws -> Bool {
        visited(.protocol, sourceLocation: declaration.sourceLocation, node: declaration)
        return true
    }

    func visit(_ declaration: ExtensionDeclaration) throws -> Bool {
        visited(.extension, sourceLocation: declaration.sourceLocation, node: declaration)
        return true
    }

    func visit(_ declaration: InitializerDeclaration) throws -> Bool {
        visited(.initializer, sourceLocation: declaration.sourceLocation, node: declaration)
        return true
    }

    func visit(_ declaration: VariableDeclaration) throws -> Bool {
        visited(.variable, sourceLocation: declaration.sourceLocation, node: declaration)
        return true
    }
    
    func visit(_ declaration: ConstantDeclaration) throws -> Bool {
        visited(.constant, sourceLocation: declaration.sourceLocation, node: declaration)
        return true
    }

    func visit(_ declaration: FunctionDeclaration) throws -> Bool {
        visited(.function, sourceLocation: declaration.sourceLocation, node: declaration)
        return true
    }

}

private extension CodeASTVisitor {

    func visited<T: ASTNode>(_ visitor: Visitor, sourceLocation: SourceLocation, node: T?) {
        if let node = node {
            visitedNodes.append(node)
        }

        codeGenerators.filter { $0.generatorConfig.visitors?.contains(visitor) ?? false }.forEach {
            if let modifier = $0.fileModifier(node: node,
                                              sourceLocation: sourceLocation,
                                              fileComponents: fileComponents,
                                              visitedNodes: visitedNodes) {
                modifications.append(modifier)
            }
        }
    }

}
