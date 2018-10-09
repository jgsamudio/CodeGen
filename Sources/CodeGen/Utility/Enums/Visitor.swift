//
//  Visitor.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation

enum Visitor: String, Codable {
    case `class`
    case `enum`
    case `protocol`
    case `struct`
    case `extension`
    case initializer
    case variable
    case constant
    case function
}
