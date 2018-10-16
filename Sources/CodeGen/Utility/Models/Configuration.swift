//
//  Configuration.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation

struct Configuration: Codable {
    
    // MARK: - Public Properties
    
    let platform: Platform
    let generators: [GeneratorConfig]
    let excludedFiles: [String]?
    let excludedDirectories: [String]?
}

struct StyleGuide: Codable {
    
}

struct StyleConfig: Codable {
    let name: String
    let enabled: Bool
    let excludedFiles: [String]?
}

enum Platform: String {
    case ios
    case android
}
