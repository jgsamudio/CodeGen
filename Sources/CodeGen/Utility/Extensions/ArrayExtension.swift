//
//  ArrayExtension.swift
//  CodeGen
//
//  Created by Jonathan Samudio on 10/8/18.
//

import Foundation

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

}
