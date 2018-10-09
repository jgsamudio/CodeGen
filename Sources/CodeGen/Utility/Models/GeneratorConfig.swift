//
//  GeneratorConfig.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation

struct GeneratorConfig: Decodable {
    let name: String
    let enabled: Bool
    let insertString: [String]?
    let visitors: [Visitor]?
    let revertChanges: Bool?
}
