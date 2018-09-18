//
//  CodeASTVisitor.swift
//  AST
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation
import AST

final class CodeASTVisitor: ASTVisitor {

    var modifications = [FileModifier]()

    func visit(_ classDeclaration: ClassDeclaration) throws -> Bool {
        print(classDeclaration.name)
        print(classDeclaration.sourceRange)

        let fileModifier = FileModifier(filePath: classDeclaration.sourceLocation.identifier,
                                        line: classDeclaration.sourceLocation.line,
                                        insertions: ["// HELLO WORLD"])

        modifications.append(fileModifier)
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

class FileModifier {

    let filePath: String
    let line: Int
    let insertions: [String]
    let deletions: [String]
    let replaceCurrentLine: Bool

    init(filePath: String,
         line: Int,
         insertions: [String] = [],
         deletions: [String] = [],
         replaceCurrentLine: Bool = false) {
        self.filePath = filePath
        self.line = line
        self.insertions = insertions
        self.deletions = deletions
        self.replaceCurrentLine = replaceCurrentLine
    }

}
