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

    init(fileComponents: [String], config: Configuration?) {
        self.fileComponents = fileComponents
        self.config = config
    }

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

    func visit(_ declaration: ExtensionDeclaration) throws -> Bool {
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
