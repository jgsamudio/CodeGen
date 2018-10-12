//
//  ArrayExtension.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 10/8/18.
//

import Foundation
import AST

typealias CommentComponentData = (index: Int, insertTopSpace: Bool)

extension Array where Element == String {

    /// Inserts tabs with the format provided.
    ///
    /// - Parameter format: Format of the tabs.
    /// - Returns: Updated array with tabs inserted.
    func insertTabs(format: TabFormat = .spaces) -> [String] {
        return map { "\(format.rawValue)\($0)" }
    }

    /// Determines if the array is equal to the bottom of the array provided.
    ///
    /// - Parameter array: Array to check the bottom of.
    /// - Returns: Boolean the returns if the bottom of the array is equal to the current array.
    func isEqual(toBottomOf array: [String]) -> Bool {
        guard array.count >= count else {
            return false
        }
        let startIndex = array.count-count
        return Array(array[startIndex..<array.count]).removeTabs() == self
    }

    /// Removes tabs from the file component array.
    ///
    /// - Parameter format: Tab format to remove the tabs. Defaults to spaces.
    /// - Returns: Updated file component array with out the tabs.
    func removeTabs(format: TabFormat = .spaces) -> [String] {
        return map { (string) -> String in
            guard !string.replacingOccurrences(of: " ", with: "").isEmpty else {
                return ""
            }

            guard string.count >= format.rawValue.count else {
                return string
            }

            let tabColumnIndex = string.index(string.startIndex, offsetBy: format.rawValue.count)
            if String(string[string.startIndex..<tabColumnIndex]) == format.rawValue {
                return String(string[tabColumnIndex..<string.endIndex])
            }
            return string
        }
    }

    /// Returns the comment component data.
    ///
    /// - Parameter startIndex: Start index of the component array.
    /// - Returns: CommentComponentData.
    func commentComponentData(startIndex: Index) -> CommentComponentData {
        return Array(self[0..<startIndex]).indexAboveComment(index: startIndex)
    }

    /// Removes the double top space from the array of components.
    ///
    /// - Parameter data: Comment component data.
    /// - Returns: Updated array of components.
    func removeDoubleTopSpace(data: CommentComponentData) -> [String] {
        var array = self
        if !data.insertTopSpace, array.first == "" {
            array.removeFirst()
        }
        return array
    }

    /// Returns the line number above comments
    ///
    /// - Parameter startLineNumber: Line number to start checking.
    /// - Returns: The updated index where there is no comment and whether an additional space should be added.
    func indexAboveComment(index: Int) -> CommentComponentData {
        for index in stride(from: index-1, through: 0, by: -1) {
            let formattedString = self[index].replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n",
                                                                                                           with: "")
            if formattedString.isComment() {
                continue
            } else {
                return (index + 1, !formattedString.isEmpty)
            }
        }
        return (0, false)
    }

}

extension Array where Element == DeclarationModifier {

    /// Determines if the modifier array is public.
    var isPublic: Bool {
        return !textDescription.contains("private") || !textDescription.contains("fileprivate")
    }

}
