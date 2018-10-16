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
    
    // MARK: - Private Properties
    
    private let arguments: [String]
    private let dataDecoder = DataDecoder()

    private var generatedFileModifiers = LinkedList<FileModifier>()

    // MARK: - Initialization
    
    init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }

    // MARK: - Public Functions
    
    func run() throws {
        let timer = ParkBenchTimer()

        guard arguments.count > 1 else {
            throw CommandLineError.missingDirectory
        }

        let directory = arguments[1]
        let config = try loadConfig(directory: directory)
        let fileNames = FileRetriever.retrieveFilenames(at: directory,
                                                        fileExtensions: [".swift"],
                                                        excludedFiles: config.excludedFiles,
                                                        excludedDirectories: config.excludedDirectories)
        let group = DispatchGroup()

        // Parse Current Files.
        for fileName in fileNames {
            group.enter()
            DispatchQueue.global().async {
                do {
                    print("Parsing: \(fileName)")
                    try self.parse(fileName: fileName, directory: directory, config: config)
                    group.leave()
                } catch {
                    print("Parsing Error: \(fileName)")
                    group.leave()
                }
            }
        }
        group.wait()

        // Generates the code given the config
        generateProjectFiles()
        
        // Store config generators for next run.
        storeConfigGenerators(config: config)
        print("Parsed \(fileNames.count) Files in \(timer.stop()) seconds.")
    }

}

// MARK: - Private Functions
private extension ArgumentParser {

    func parse(fileName: String, directory: String, config: Configuration) throws {
        let sourceFile = try SourceReader.read(at: "\(directory)/\(fileName)")
        let fileComponents = sourceFile.content.components(separatedBy: "\n")

        let parser = Parser(source: sourceFile)
        let topLevelDecl = try parser.parse()
        let visitor = CodeASTVisitor(fileComponents: fileComponents, config: config)
        _ = try? visitor.traverse(topLevelDecl)

        // Save generated file modifiers.
        if let fileModifiers = visitor.modifications[FileModifierType.generatedFile] {
            if generatedFileModifiers.tail == nil {
                generatedFileModifiers = fileModifiers
            } else {
                generatedFileModifiers.tail?.next = fileModifiers.head
                generatedFileModifiers.tail = fileModifiers.tail
            }
        }

        // Ensure there are modifications to make.
        guard let list = visitor.modifications[FileModifierType.fileModified] else {
            return
        }

        // Update files with modifications.
        let updatedComponentList = LinkedList<String>()
        for i in 0..<fileComponents.count {
            let fileComponent = fileComponents[i]
            var replaceCurrentLine = false

            // Check Modifications
            var currentNode = list.head
            while currentNode != nil {
                if let modification = currentNode?.value as? ProjectFileModifier, modification.startIndex == i {
                    updatedComponentList.append(modification.insertions.joined(separator: "\n"))
                    replaceCurrentLine = modification.replaceCurrentLine
                    // Deletions should be a range
                }
                currentNode = currentNode?.next
            }

            // Append line if needed.
            if !replaceCurrentLine {
                updatedComponentList.append(fileComponent)
            }
        }
        updatedComponentList.joined(separator: "\n").writeToFile(directory: "\(directory)/\(fileName)")
    }

    func generateProjectFiles() {
        var currentNode = generatedFileModifiers.head
        while currentNode != nil {
            if let modification = currentNode?.value as? GeneratedFileModifier {
                print(modification.parameters)
                let insertString = modification.generatorConfig.insertString?.joined().stringBetween(startString: "<List>", endString: "</List>")
                print(insertString)
            }
            currentNode = currentNode?.next
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

    func storeConfigGenerators(config: Configuration) {
        // TODO: Save Directory for changing projects.
        for generator in config.generators {
            generator.storeGenerator()
        }
    }

}

enum TemplateCommand: String {
    case list = "<List>"
}
