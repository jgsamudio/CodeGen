//
//  Configuration.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation

struct Configuration: Decodable {
    let generators: [Generator]
    let excluded: [String]?
}
