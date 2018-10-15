//
//  GeneratorConfig.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation

struct GeneratorConfig: Codable {
    
    // MARK: - Public Properties
    
    let name: String
    let enabled: Bool
    let insertString: [String]?
    let visitors: [Visitor]?
    let excludedFiles: [String]?
}
