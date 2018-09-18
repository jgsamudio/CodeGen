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

    private var fileNameDict = [String: [String]]()

    init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }

    func run() throws {
        guard arguments.count > 1 else {
            throw CommandLineError.missingDirectory
        }

        let directory = arguments[1]
        let fileNames = FileRetriever.retrieveFilenames(at: directory, fileExtensions: [".swift"])
        let visitor = CodeASTVisitor()

        for fileName in fileNames {
            let sourceFile = try SourceReader.read(at: "\(directory)/\(fileName)")
            let parser = Parser(source: sourceFile)
            let topLevelDecl = try parser.parse()
            _ = try? visitor.traverse(topLevelDecl)

            print(visitor.modifications.count)
            var fileComponents = sourceFile.content.components(separatedBy: "\n")
            var updatedFileComponents = [String]()

            for i in 0..<fileComponents.count {
                let line = i+1
                let fileComponent = fileComponents[i]
                var replaceCurrentLine = false

                for modIndex in 0..<visitor.modifications.count {
                    let modification = visitor.modifications[modIndex]

                    if modification.line == line {
                        updatedFileComponents.insert(modification.insertions.joined(separator: "\n"), at: i)
                        visitor.modifications.remove(at: modIndex)

                        if !modification.replaceCurrentLine {
                            replaceCurrentLine = true
                        }
                    }
                }

                if !replaceCurrentLine {
                    updatedFileComponents.append(fileComponent)
                }
            }

            updatedFileComponents.joined(separator: "\n").writeToFile(directory: "\(directory)/\(fileName)")
        }
    }

}
