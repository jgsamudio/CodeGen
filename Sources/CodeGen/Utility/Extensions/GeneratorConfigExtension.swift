//
//  GeneratorConfigExtension.swift
//  AST
//
//  Created by Jonathan Samudio on 10/9/18.
//

import Foundation

extension GeneratorConfig {

    var generatorInsertStringUpdated: Bool {
        return originalGeneratorInsertString != insertString
    }

    var originalGeneratorInsertString: [String]? {
        return UserDefaults.standard.object(forKey: name) as? [String]
    }

    func storeGenerator() {
        UserDefaults.standard.set(insertString, forKey: name)
        print(originalGeneratorInsertString)
    }

}
