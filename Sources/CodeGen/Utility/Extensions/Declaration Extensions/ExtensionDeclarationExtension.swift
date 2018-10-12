//
//  ExtensionDeclarationExtension.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 10/9/18.
//

import Foundation
import AST

extension ExtensionDeclaration {

    /// Checks if the extension declaration contains the declaration given.
    ///
    /// - Parameter declaration: Declaration to check for.
    /// - Returns: Boolean if the declaration was found.
    func contains(declaration: Declaration) -> Bool {
        for member in members {
            switch member {
            case .declaration(let declaration):
                if declaration.description == declaration.description {
                    return true
                }
            default:
                continue
            }
        }
        return false
    }

}

extension FunctionDeclaration {

    /// Checks if the function declaration contains the declaration given.
    ///
    /// - Parameter declaration: Declaration to check for.
    /// - Returns: Boolean if the declaration was found.
    func contains(declaration: Declaration) -> Bool {
        guard let statements = body?.statements else {
            return false
        }
        for statement in statements {
            if statement.description == declaration.description {
                return true
            }
        }
        return false
    }

}
