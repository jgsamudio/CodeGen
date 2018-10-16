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
    let conformance: String?
    let newFileGenerator: NewFileGenerator?
}

struct NewFileGenerator: Codable {
    let name: String
    let path: String
    let header: String?
}
