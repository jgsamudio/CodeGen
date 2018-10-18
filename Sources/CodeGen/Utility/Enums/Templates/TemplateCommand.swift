//
//  TemplateCommand.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 10/18/18.
//

import Foundation

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

    // MARK: - Public Functions
    
    func generatedString(templateString: String, templateDict: [TemplateParameter: [String]]) -> String {
        switch self {
        case .list:
            var generatedString = ""

            for (parameter, values) in templateDict {
                guard templateString.contains(parameter.rawValue) else {
                    continue
                }
                let sortedValues = values.sorted()
                for value in sortedValues {
                    let valueString = templateString.replacingOccurrences(of: parameter.rawValue, with: value)
                    if let lastValue = sortedValues.last {
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
