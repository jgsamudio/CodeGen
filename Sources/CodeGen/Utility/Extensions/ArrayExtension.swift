//
//  ArrayExtension.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 10/8/18.
//

import Foundation

typealias CommentComponentData = (index: Int, insertTopSpace: Bool)

extension Array where Element == String {

    func insertTabs(format: TabFormat = .spaces) -> [String] {
        return map { "\(format.rawValue)\($0)" }
    }

    func isEqual(toBottomOf array: [String]) -> Bool {
        guard array.count >= count else {
            return false
        }
        let startIndex = array.count-count
        return Array(array[startIndex..<array.count]).removeTabs() == self
    }

    func removeTabs(format: TabFormat = .spaces) -> [String] {
        return map { (string) -> String in
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

    func commentComponentData(startIndex: Index) -> CommentComponentData {
        return Array(self[0..<startIndex]).indexAboveComment(index: startIndex)
    }

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
            let formattedString = self[index].replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
            if formattedString.isComment() {
                continue
            } else {
                return (index + 1, !formattedString.isEmpty)
            }
        }
        return (0, false)
    }

}
