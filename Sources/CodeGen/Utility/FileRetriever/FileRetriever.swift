//
//  FileRetriever.swift
//  AST
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation

typealias SourceFile = (fileNameUrl: URL, content: String, components: [String])

struct FileRetriever {

    static func retrieveFilenames(at path: String, fileExtensions: [String]?) -> [String] {
        let fileEnumerator = FileManager.default.enumerator(atPath: path)
        let enumerator = fileEnumerator?.filter { (file) in
            if let fileExtensions = fileExtensions {
                return !(fileExtensions.filter { (file as? String)?.contains($0) ?? false }.isEmpty)
            }
            return true
        }

        guard let filteredFileEnumerator = enumerator as? [String] else {
            print("Error filtering files.")
            return []
        }
        return filteredFileEnumerator
    }

    static func loadSourceFiles(fileNames: [String], directory: String) -> [SourceFileLoader] {
        let fileLoaders = fileNames.map { SourceFileLoader(directory: directory, fileName: $0) }
        fileLoaders.forEach { $0.loadFiles() }
        return fileLoaders
    }

}
