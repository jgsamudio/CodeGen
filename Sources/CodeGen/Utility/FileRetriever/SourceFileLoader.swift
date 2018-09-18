//
//  SourceFileLoader.swift
//  AST
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation

class SourceFileLoader {

    var sourceFile: SourceFile?
    
    var fileNameUrl: URL {
        return URL(string: fileName.replacingOccurrences(of: " ", with: "%20")) ?? URL(string: "hello")!
    }

    var fileToParse: String {
        return "\(directory)/\(fileName)".replacingOccurrences(of: " ", with: "%20")
    }

    private var directory: String
    private var fileName: String

    init(directory: String, fileName: String) {
        self.directory = directory
        self.fileName = fileName
    }

    func loadFiles(completion: (()->Void)? = nil) {
        do {
            let content = try String(contentsOfFile: "\(self.directory)/\(self.fileName)", encoding: String.Encoding.utf8)
            let fileComponents = content.components(separatedBy: "\n")
            self.sourceFile = ((self.fileNameUrl, content, fileComponents))
            if let completion = completion {
                completion()
            }
        } catch {
            print("Error caught with message: \(error.localizedDescription)")
        }
    }

}
