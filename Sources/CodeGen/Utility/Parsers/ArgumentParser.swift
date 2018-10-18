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
        generateTemplateCommands(directory: directory, projectConfig: config)

        
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

    func generateTemplateCommands(directory: String, projectConfig: Configuration) {
        for (_, generator) in generatedFileModifiers {
            let config = generator.generatorConfig
            if let path = config.newFileGenerator?.path,
                let name = config.newFileGenerator?.name,
                let generatedString = TemplateCommand.commands(insertString: config.insertString,
                                                               templateDict: generator.parameters) {
                let header = projectConfig.fileHeader(name: name)
                "\(header)\n\(generatedString)".writeToFile(directory: "\(directory)\(path)\(name)")
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

enum TemplateCommand: String, CaseIterable {
    case list

    // MARK: - Public Properties
    
    var startToken: String {
        switch self {
        case .list:
            return "<CommaList>"
        }
    }

    var endToken: String {
        switch self {
        case .list:
            return "</CommaList>"
        }
    }

    func generatedString(templateString: String, templateDict: [TemplateParameter: [String]]) -> String {
        switch self {
        case .list:
            var generatedString = ""

            for (parameter, values) in templateDict {
                guard templateString.contains(parameter.rawValue) else {
                    continue
                }
                for value in values {
                    let valueString = templateString.replacingOccurrences(of: parameter.rawValue, with: value)
                    if let lastValue = values.last {
                        let separator = (value == lastValue) ? "" : ",\n"
                        generatedString.append("\(valueString)\(separator)")
                    }
                }
            }
            return generatedString
        }
    }

    static func commands(insertString: [String]?, templateDict: [TemplateParameter: [String]]) -> String? {
        guard let insertString = insertString else {
            return nil
        }

        var updatedList = insertString.joined(separator: "\n")
        for command in TemplateCommand.allCases {
            if let templateString = insertString.joined().stringBetween(startString: command.startToken,
                                                                        endString: command.endToken) {

                let generatedString = command.generatedString(templateString: templateString,
                                                              templateDict: templateDict)
                let templateCommand = command.completeTemplateCommand(templateString: templateString)
                updatedList = updatedList.replacingOccurrences(of: templateCommand, with: generatedString)
            }
        }
        return updatedList
    }

    func completeTemplateCommand(templateString: String) -> String {
        return "\(startToken)\(templateString)\(endToken)"
    }
}

enum TemplateParameter: String {
    case name = "%name%"
}
