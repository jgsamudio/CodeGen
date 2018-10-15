//
//  SourceFileLoader.swift
//  AST
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation

class SourceFileLoader {

    // MARK: - Public Properties
    
    var sourceFile: SourceFile?
    
    var fileNameUrl: URL {
        return fileName.urlFilePath ?? URL(string: "hello")!
    }

    var fileToParse: String {
        return "\(directory)/\(fileName)".replacingOccurrences(of: " ", with: "%20")
    }

    private var directory: String
    private var fileName: String

    // MARK: - Initialization
    
    init(directory: String, fileName: String) {
        self.directory = directory
        self.fileName = fileName
    }

    // MARK: - Public Functions
    
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
