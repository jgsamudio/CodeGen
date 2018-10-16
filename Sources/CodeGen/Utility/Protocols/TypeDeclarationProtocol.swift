//
//  TypeDeclarationProtocol.swift
//  AST
//
//  Created by Jonathan Samudio on 10/16/18.
//

import Foundation
import AST

protocol TypeDeclarationProtocol: Declaration {

    var name: Identifier { get }

    var typeInheritanceClause: TypeInheritanceClause? { get }

}

// MARK: - TypeDeclarationProtocol
extension ClassDeclaration: TypeDeclarationProtocol {

}

// MARK: - TypeDeclarationProtocol
extension StructDeclaration: TypeDeclarationProtocol {

}
