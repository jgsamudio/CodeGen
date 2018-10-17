//
//  CodeASTVisitor.swift
//  AST
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation
import AST
import Source

typealias VisitedNodeCollection = [Visitor: LinkedList<ASTNode>]

final class CodeASTVisitor: ASTVisitor {

    // MARK: - Public Properties
    
    var projectFileModifications = LinkedList<ProjectFileModifier>()
    var generatedFileModifications = [String: GeneratedFileModifier]()

    // MARK: - Private Properties
    
    // TODO: STYLE - Auto generate the order of the variables.
    private var visitedNodes: VisitedNodeCollection
    private var codeGenerators = [Visitor: LinkedList<CodeGenerator>]()

    private let fileComponents: [String]
    private let config: Configuration?

    // MARK: - Initialization
    
    init(fileComponents: [String], config: Configuration?) {
        self.fileComponents = fileComponents
        self.config = config
        self.visitedNodes = VisitedNodeCollection()

        // Init the code generators.
        for configGenerator in config?.generators ?? [] {
            if configGenerator.enabled, let generatorType = CodeGeneratorDataSource.availableGeneratorDict[configGenerator.name] {
                let generator = generatorType.init(generatorConfig: configGenerator)
                for visitor in configGenerator.visitors ?? [] {
                    if let list = codeGenerators[visitor] {
                        list.append(generator)
                        codeGenerators[visitor] = list
                    } else {
                        let list = LinkedList<CodeGenerator>()
                        list.append(generator)
                        codeGenerators[visitor] = list
                    }
                }
            }
        }
    }

    // MARK: - Public Functions
    
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

// MARK: - Private Functions
private extension CodeASTVisitor {

    func visited<T: ASTNode>(_ visitor: Visitor, sourceLocation: SourceLocation, node: T?) {
        updateVisitedNodes(visitor, node: node)

        let codeGeneratorList = codeGenerators[visitor]
        var currentNode = codeGeneratorList?.head
        while currentNode != nil {
            if let currentNode = currentNode,
                !currentNode.value.sourceExcluded(sourceLocation),
                let modifier = currentNode.value.fileModifier(node: node,
                                                              sourceLocation: sourceLocation,
                                                              fileComponents: fileComponents,
                                                              visitedNodes: visitedNodes) {
                updateModifications(modifier: modifier)
            }
            currentNode = currentNode?.next
        }
    }

    // TODO: GENERATOR - Automate duplicated code.
    func updateVisitedNodes(_ visitor: Visitor, node: ASTNode?) {
        guard let node = node else {
            return
        }
        if let list = visitedNodes[visitor] {
            list.append(node)
            visitedNodes[visitor] = list
        } else {
            let list = LinkedList<ASTNode>()
            list.append(node)
            visitedNodes[visitor] = list
        }
    }

    func updateModifications(modifier: FileModifier) {
        switch modifier.type {
        case .fileModified:
            if let modifier = modifier as? ProjectFileModifier {
                projectFileModifications.append(modifier)
            }
        case .generatedFile:
            if let modifier = modifier as? GeneratedFileModifier {
                if let generatedModifier = generatedFileModifications[modifier.generatorConfig.name]  {
                    generatedModifier.merge(modifier: modifier)
                    generatedFileModifications[modifier.generatorConfig.name] = generatedModifier
                } else {
                    generatedFileModifications[modifier.generatorConfig.name] = modifier
                }
            }
        }
    }

}
