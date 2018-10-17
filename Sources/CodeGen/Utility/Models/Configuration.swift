//
//  Configuration.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 9/18/18.
//

import Foundation

struct Configuration: Codable {
    
    // MARK: - Public Properties

    /// Name of the author / developer.
    let authorName: String

    /// Company name.
    let companyName: String

    /// Project name.
    let projectName: String

    let generators: [GeneratorConfig]
    let excludedFiles: [String]?
    let excludedDirectories: [String]?
}

extension Configuration {

    func fileHeader(name: String) -> String {
        return """
        //
        //  \(name)
        //  \(projectName)
        //
        //  Created by \(authorName) on \(Date.currentDateString).
        //  Copyright © \(Date.currentYearString) \(companyName). All rights reserved.
        //

        /*
        Auto-Generated using CodeGen
        */

        """
    }

}

extension Date {

    static var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        let formattedDate = formatter.string(from: Date())
        return formattedDate
    }

    static var currentYearString: String {
        let date = Date()
        let calendar = Calendar.current
        return String(calendar.component(.year, from: date))
    }
}
