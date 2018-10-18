//
//  GeneratedFileModifier.swift
//  AST
//
//  Created by Jonathan Samudio on 10/18/18.
//

import Foundation

class GeneratedFileModifier: FileModifier {

    // MARK: - Public Properties
    
    var type = FileModifierType.generatedFile

    let generatorConfig: GeneratorConfig

    // MARK: - Private Properties

    private(set) var parameters: [TemplateParameter: [String]]

    // MARK: - Initialization
    
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
