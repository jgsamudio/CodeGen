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
import Alamofire

final class ArgumentParser {

    private let arguments: [String]
    private let dataDecoder = DataDecoder()

    init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }

    func run() throws {
        guard arguments.count > 1 else {
            throw CommandLineError.missingDirectory
        }

        let directory = arguments[1]
        let config = try loadConfig(directory: directory)
        let fileNames = FileRetriever.retrieveFilenames(at: directory, fileExtensions: [".swift"])

        // Parse files.
        for fileName in fileNames {
            let sourceFile = try SourceReader.read(at: "\(directory)/\(fileName)")
            let fileComponents = sourceFile.content.components(separatedBy: "\n")

            let parser = Parser(source: sourceFile)
            let topLevelDecl = try parser.parse()
            let visitor = CodeASTVisitor(fileComponents: fileComponents, config: config)
            _ = try? visitor.traverse(topLevelDecl)

            // Update files with modifications.
            var updatedFileComponents = [String]()
            for i in 0..<fileComponents.count {
                let lineNumber = i+1
                let fileComponent = fileComponents[i]
                var replaceCurrentLine = false

                // Check Modifications
                for modIndex in 0..<visitor.modifications.count {
                    let modification = visitor.modifications[modIndex]
                    if modification.lineNumber == lineNumber {
                        updatedFileComponents.insert(modification.insertions.joined(separator: "\n"), at: i)
                        replaceCurrentLine = modification.replaceCurrentLine
                    }
                }

                // Append line if needed.
                if !replaceCurrentLine {
                    updatedFileComponents.append(fileComponent)
                }
            }
            updatedFileComponents.joined(separator: "\n").writeToFile(directory: "\(directory)/\(fileName)")
        }
    }

    func loadConfig(directory: String) throws -> Configuration {
        let jsonString = try? String(contentsOfFile: "\(directory)/.codegen.config.json", encoding: String.Encoding.utf8)
        let data = jsonString?.data(using: .utf8)
        let result: Result<Configuration> = dataDecoder.decodeData(data)
        if let config = result.value {
            return config
        } else {
            throw CommandLineError.configFileMissing
        }
    }

}
