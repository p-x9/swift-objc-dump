//
//  String+.swift
//
//
//  Created by p-x9 on 2024/06/19
//  
//

import Foundation

extension String {
    /// Finds the index of the matching closing bracket for a given opening bracket.
    /// - Parameters:
    ///   - open: The opening bracket character.
    ///   - close: The closing bracket character.
    /// - Returns: The index of the matching closing bracket if found, otherwise `nil`.
    /// - Complexity: O(n), where n is the length of the string.
    func indexForMatchingBracket(
        open: Character,
        close: Character
    ) -> Int? {
        var depth = 0
        for (index, char) in enumerated() {
            depth += (char == open) ? 1 : (char == close) ? -1 : 0
            if depth == 0 {
                return index
            }
        }
        return nil
    }
    
    /// Extracts the initial sequence of numeric characters from the string.
    /// - Returns: A string containing the initial sequence of numeric characters if any, otherwise `nil`.
    /// - Complexity: O(n), where n is the length of the string.
    func readInitialDigits() -> String? {
        var digits = ""
        for char in self {
            if char.isNumber {
                digits.append(char)
            } else {
                break
            }
        }
        return digits.isEmpty ? nil : digits
    }
}
