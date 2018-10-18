//
//  NewFileGenerator.swift
//  AST
//
//  Created by Jonathan Samudio on 10/16/18.
//

import Foundation

struct NewFileGenerator: Codable {
    
    // MARK: - Public Properties
    
    let name: String
    let path: String
    let header: String?
    let singleFileGeneration: Bool?
}
