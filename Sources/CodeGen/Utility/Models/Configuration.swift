//
//  Configuration.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation

struct Configuration: Codable {
    
    // MARK: - Public Properties
    
    let generators: [GeneratorConfig]
    let excluded: [String]?
}
