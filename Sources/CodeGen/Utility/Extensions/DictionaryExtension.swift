//
//  DictionaryExtension.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 10/9/18.
//

import Foundation
import AST

extension Dictionary where Key: Hashable, Value: LinkedList<ASTNode> {

    /// Determines if the function given is found in a extension.
    ///
    /// - Parameter function: Function to check for.
    /// - Returns: Boolean if the function is found in a private extension.
    func extensionFunctionFound(with function: FunctionDeclaration) -> Bool {
        guard let vistedNodeCollection = self as? VisitedNodeCollection else {
            return false
        }

        let extensionList = vistedNodeCollection[.extension]
        var currentNode = extensionList?.head
        
        while currentNode != nil {
            if let extensionDeclaration = currentNode?.value as? ExtensionDeclaration,
                extensionDeclaration.accessLevelModifier == .`private` ||
                    extensionDeclaration.accessLevelModifier == .fileprivate,
                extensionDeclaration.contains(declaration: function) {
                return true
            }
            currentNode = currentNode?.next
        }
        return false
    }

}
