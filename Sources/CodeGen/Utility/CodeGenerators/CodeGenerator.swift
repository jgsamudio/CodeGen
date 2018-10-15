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
    ///   - visitedNodes: Visited nodes of the file.
    /// - Returns: Optional file modifier with any changes.
    func fileModifier<T: ASTNode>(node: T?,
                                  sourceLocation: SourceLocation,
                                  fileComponents: [String],
                                  visitedNodes: VisitedNodeCollection) -> FileModifier?
    
}

extension CodeGenerator {

    /// Determines if the insert string is found.
    ///
    /// - Parameters:
    ///   - insertions: Array of string insertions to check if the file has.
    ///   - fileComponents: File components of the swift file.
    ///   - sourceLocation: Location with in the source file.
    /// - Returns: Boolean if the insert string is found or not.
    func foundInsertions(_ insertions: [String]?, fileComponents: [String], startIndex: Int) -> Bool {
        return insertions?.isEqual(toBottomOf: Array(fileComponents[0..<startIndex])) ?? false
    }

    func validNode<T: ASTNode>(_ node: T,
                               visitedNodes: VisitedNodeCollection,
                               ignoredVisitors: [Visitor] = [],
                               visitedNodesValidator: ((ASTNode)->(Bool))? = nil) -> Bool {
        return ignoredVisitors.reduce(true, { (result, ignoredVisitor) -> Bool in
            return result && !foundItem(with: node.sourceLocation, in: visitedNodes[ignoredVisitor])
        })
    }

    func foundItem<T: ASTNode>(with location: SourceLocation,
                               in list: LinkedList<T>?,
                               visitedNodeValidator: ((ASTNode)->(Bool))? = nil) -> Bool {
        var currentNode = list?.head

        while currentNode != nil {
            if let currentNode = currentNode,
                currentNode.value.sourceRange.start.line < location.line &&
                    currentNode.value.sourceRange.end.line > location.line &&
                    (visitedNodeValidator?(currentNode.value) ?? true) {
                return true
            }
            currentNode = currentNode?.next
        }
        return false
    }

    func sourceExcluded(_ sourceLocation: SourceLocation) -> Bool{
        if let fileNameWithExtension = URL(string: sourceLocation.identifier)?.lastPathComponent,
            generatorConfig.excludedFiles?.contains(fileNameWithExtension) ?? false {
            return true
        }
        return false
    }
    
}
