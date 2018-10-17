//
//  FileModifier.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation

protocol FileModifier {

    var type: FileModifierType { get }

}

final class ProjectFileModifier: FileModifier {

    // MARK: - Public Properties

    var type = FileModifierType.fileModified
    
    let filePath: String
    let startIndex: Int
    let insertions: [String]
    let deletions: [String]
    let replaceCurrentLine: Bool

    // MARK: - Initialization
    
    init(filePath: String,
         startIndex: Int,
         insertions: [String] = [],
         deletions: [String] = [],
         replaceCurrentLine: Bool = false) {
        self.filePath = filePath
        self.startIndex = startIndex
        self.insertions = insertions
        self.deletions = deletions
        self.replaceCurrentLine = replaceCurrentLine
    }

}

class GeneratedFileModifier: FileModifier {

    var type = FileModifierType.generatedFile

    let generatorConfig: GeneratorConfig
    
    // MARK: - Private Properties
    
    private(set) var parameters: [TemplateParameter: [String]]

    init(generatorConfig: GeneratorConfig, parameters: [TemplateParameter: [String]]) {
        self.generatorConfig = generatorConfig
        self.parameters = parameters
    }

    // MARK: - Public Functions
    
    func merge(modifier: GeneratedFileModifier) {
        for (parameter, values) in modifier.parameters {
            if var parameterValues = parameters[parameter] {
                parameterValues.append(contentsOf: values)
                parameters[parameter] = parameterValues
            } else {
                parameters[parameter] = values
            }
        }
    }

}

enum FileModifierType {
    case fileModified
    case generatedFile
}
