//
//  FileRetriever.swift
//  AST
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation

typealias SourceFile = (fileNameUrl: URL, content: String, components: [String])

struct FileRetriever {

    // MARK: - Public Functions
    
    static func retrieveFilenames(at path: String,
                                  fileExtensions: [String]?,
                                  excludedFiles: [String]?,
                                  excludedDirectories: [String]?) -> [String] {

        let fileEnumerator = FileManager.default.enumerator(atPath: path)
        let enumerator = fileEnumerator?.filter { (file) in
            guard let filePath = file as? String,
                let filePathURL = filePath.urlFilePath,
                !(excludedFiles?.contains(filePathURL.lastPathComponent) ?? false) else {
                return false
            }

            if let excludedDirectories = excludedDirectories {
                for excludedDirectory in excludedDirectories {
                    if filePathURL.pathComponents.contains(excludedDirectory) {
                        return false
                    }
                }
            }

            guard let fileExtensions = fileExtensions else {
                return true
            }

            if let extensionIndex = filePath.index(of: ".") {
                let currentFileExtension = String(filePath[extensionIndex..<filePath.endIndex])
                return fileExtensions.contains(currentFileExtension)
            } else {
                return false
            }
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
