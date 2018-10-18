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
    private let dispatchGroup = DispatchGroup()

    private var generatedFileModifiers = [String: GeneratedFileModifier]()

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
                                                        excludedDirectories: config.excludedDirectories).sorted()

        // Parse Current Files.
        for fileName in fileNames {
            dispatchGroup.enter()
            DispatchQueue.global().async {
                do {
                    print("Parsing: \(fileName)")
                    try self.parse(fileName: fileName, directory: directory, config: config)
                    self.dispatchGroup.leave()
                } catch {
                    print("Parsing Error: \(fileName)")
                    self.dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.wait()

        // Generates the code given the config
        generateTemplateCommands(directory: directory, projectConfig: config, fileNames: fileNames)

        dispatchGroup.wait()

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
        for (_, modification) in visitor.generatedFileModifications {
            generatedFileModifiers.append(modification: modification)
        }

        // Ensure there are modifications to make.
        guard let listHead = visitor.projectFileModifications.head else {
            return
        }

        // Update files with modifications.
        let updatedComponentList = LinkedList<String>()
        for i in 0..<fileComponents.count {
            let fileComponent = fileComponents[i]
            var replaceCurrentLine = false

            // Check Modifications
            var currentNode: LinkedListNode<ProjectFileModifier>? = listHead
            while currentNode != nil {
                if let modification = currentNode?.value, modification.startIndex == i {
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

    func generateTemplateCommands(directory: String, projectConfig: Configuration, fileNames: [String]) {
        for (_, generator) in generatedFileModifiers {
            dispatchGroup.enter()
            DispatchQueue.global().async {
                let config = generator.generatorConfig
                guard let newFileGenerator = config.newFileGenerator,
                    let path = config.newFileGenerator?.path,
                    let name = config.newFileGenerator?.name,
                    !(fileNames.contains("\(path)\(name)") && newFileGenerator.singleFileGeneration ?? false) else {
                        self.dispatchGroup.leave()
                        return
                }

                if let path = config.newFileGenerator?.path,
                    let name = config.newFileGenerator?.name,
                    let generatedString = TemplateCommand.commands(insertString: config.insertString,
                                                                   templateDict: generator.parameters) {
                    let header = projectConfig.fileHeader(name: name)
                    "\(header)\n\(generatedString)".writeToFile(directory: "\(directory)/\(path)\(name)")
                }
                self.dispatchGroup.leave()
            }
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
