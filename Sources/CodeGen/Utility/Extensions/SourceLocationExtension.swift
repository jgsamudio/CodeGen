//
//  SourceLocationExtension.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 10/8/18.
//

import Source

extension SourceLocation {

    // MARK: - Public Properties
    
    var tabString: String {
        return String(repeating: " ", count: column-1)
    }

    var index: Int {
        return line-1
    }

}
