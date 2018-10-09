//
//  DeclarationModifierProtocol.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 10/9/18.
//

import Foundation
import AST

protocol DeclarationModifierProtocol {

    var modifiers: DeclarationModifiers { get }

}

extension VariableDeclaration: DeclarationModifierProtocol {}
extension ConstantDeclaration: DeclarationModifierProtocol {}
