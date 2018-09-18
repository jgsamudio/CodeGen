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

    private let fileComponents: [String]

    init(fileComponents: [String]) {
        self.fileComponents = fileComponents
    }

    var modifications = [FileModifier]()

    func visit(_ declaration: ClassDeclaration) throws -> Bool {
        print(declaration.name)
        checkFileHeader(sourceLocation: declaration.sourceLocation)
        return true
    }

    func visit(_ declaration: StructDeclaration) throws -> Bool {
        print(declaration.name)
        checkFileHeader(sourceLocation: declaration.sourceLocation)
        return true
    }

    func visit(_ declaration: EnumDeclaration) throws -> Bool {
        print(declaration.name)
        checkFileHeader(sourceLocation: declaration.sourceLocation)
        return true
    }

}

private extension CodeASTVisitor {

    func checkFileHeader(sourceLocation: SourceLocation) {
        let fileModifier = FileModifier(filePath: sourceLocation.identifier,
                                        lineNumber: sourceLocation.line,
                                        insertions: ["// HELLO WORLD"])

        let index = sourceLocation.line-1
        if Array(fileComponents[index-fileModifier.insertions.count..<index]) != fileModifier.insertions {
            // add check for comments.
            modifications.append(fileModifier)
        }
    }

}
