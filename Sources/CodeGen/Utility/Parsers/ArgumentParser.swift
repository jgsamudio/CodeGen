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
        let fileNames = FileRetriever.retrieveFilenames(at: directory, fileExtensions: [".swift"])
        let config = try loadConfig(directory: directory)

        // Parse files.
        for fileName in fileNames {
            // TODO: Make multi threaded.
            print(fileName)
            let sourceFile = try SourceReader.read(at: "\(directory)/\(fileName)")
            let fileComponents = sourceFile.content.components(separatedBy: "\n")

            let parser = Parser(source: sourceFile)
            let topLevelDecl = try parser.parse()
            let visitor = CodeASTVisitor(fileComponents: fileComponents, config: config)
            _ = try? visitor.traverse(topLevelDecl)

            // Update files with modifications.
            let updatedComponentList = LinkedList<String>()
            for i in 0..<fileComponents.count {
                let fileComponent = fileComponents[i]
                var replaceCurrentLine = false

                // Check Modifications
                for modIndex in 0..<visitor.modifications.count {
                    let modification = visitor.modifications[modIndex]
                    if modification.startIndex == i {
                        updatedComponentList.append(modification.insertions.joined(separator: "\n"))
                        replaceCurrentLine = modification.replaceCurrentLine
                        // Deletions should be a range
                    }
                }

                // Append line if needed.
                if !replaceCurrentLine {
                    updatedComponentList.append(fileComponent)
                }
            }
            updatedComponentList.joined(separator: "\n").writeToFile(directory: "\(directory)/\(fileName)")
        }

        // Store config generators for next run.
        storeConfigGenerators(config: config)
    }

}

private extension ArgumentParser {

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

    func storeConfigGenerators(config: Configuration) {
        // TODO: Save Directory for changing projects.
        for generator in config.generators {
            generator.storeGenerator()
        }
    }

}
