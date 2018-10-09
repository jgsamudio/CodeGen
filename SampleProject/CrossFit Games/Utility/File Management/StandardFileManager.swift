//
//  FileManager.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/22/17.
//  Copyright © Prolific Interactive. All rights reserved.
//

import Foundation

/// Manages file operations
struct StandardFileManager {

    /// Reads values from property file by name
    /// Parameters
    ///     - path: file path
    static func readPropertyFile(byPath path: String) -> Any? {
        if let path = Bundle.main.path(forResource: path, ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        return nil
    }

    /// Reads the absolute file URL for a given file name and the type
    ///
    /// - Parameters:
    ///   - path: file path
    ///   - type: file type
    /// - Returns: optional URL
    static func readFileURL(byPath path: String, type: String) -> URL? {
        guard let path = Bundle.main.path(forResource: path, ofType: type) else {
            return nil
        }
        return URL(fileURLWithPath: path)
    }

    /// Writes an encodable object to a default/ user preffered file
    /// Parameters -
    ///     - object: generic object to be written
    ///     - fileName: optional file name if required
    static func writeObject<T: Encodable> (object: T, fileName: String? = nil) throws {
        do {
            let payload: Data = try JSONEncoder().encode(object)
            var file = String(describing: T.self)
            if let newFileName = fileName, !newFileName.isEmpty {
                file = newFileName
            }
            let documentDirURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

            let fileURL = documentDirURL.appendingPathComponent(file).appendingPathExtension("dat")

            try payload.write(to: fileURL, options: .atomicWrite)
        } catch {
            throw error
        }
    }

    /// Reads a decodable object from a default/ user preffered file
    /// Parameters -
    ///     - object type: generic object to be read
    ///     - fileName: optional file name if required
    /// Returns - Onject which was read
    static func readObject<T: Decodable> (type: T.Type, fileName: String? = nil) throws -> T {
        var file = String(describing: T.self)
        if let newFileName = fileName, !newFileName.isEmpty {
            file = newFileName
        }
        let documentDirURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirURL.appendingPathComponent(file).appendingPathExtension("dat")

        do {
            let readData = try Data(contentsOf: fileURL)
            let readObject = try JSONDecoder().decode(T.self, from: readData)
            return readObject
        } catch {
            throw error
        }
    }
    
}
