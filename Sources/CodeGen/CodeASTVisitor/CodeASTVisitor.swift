//
//  CodeASTVisitor.swift
//  AST
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation
import AST

final class CodeASTVisitor: ASTVisitor {

    func visit(_ classDeclaration: ClassDeclaration) throws -> Bool {
        print(classDeclaration.name)
        print(classDeclaration.sourceLocation)
        return true
    }

    func visit(_: StructDeclaration) throws -> Bool {
        return true
    }

    func visit(_: EnumDeclaration) throws -> Bool {
        return true
    }

}

private extension CodeASTVisitor {

    func checkFileHeader() {

    }

}
