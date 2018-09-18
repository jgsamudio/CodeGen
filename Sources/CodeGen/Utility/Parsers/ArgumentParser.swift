//
//  ArgumentParser.swift
//  AST
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation
import AST
import Parser
import Source

final class ArgumentParser {

    private let arguments: [String]

    init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }

    func run() throws {
        guard arguments.count > 1 else {
            throw CommandLineError.missingDirectory
        }

        let directory = arguments[1]
        let fileNames = FileRetriever.retrieveFilenames(at: directory, fileExtensions: [".swift"]).map {
            "\(directory)/\($0)"
        }

        let visitor = CodeASTVisitor()

        for fileName in fileNames {
            let sourceFile = try SourceReader.read(at: fileName)
            let parser = Parser(source: sourceFile)
            let topLevelDecl = try parser.parse()
            _ = try? visitor.traverse(topLevelDecl)
        }
    }

}

enum CommandLineError: Error {
    case missingDirectory
}
