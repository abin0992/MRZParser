//
//  String+Extensions.swift
//  MRZParser
//
//  Created by Abin Baby on 07.11.22.
//  Copyright © 2022 Safened - Fourthline B.V. All rights reserved.
//

import Foundation

extension String {
    var trimmingFillers: String {
        trimmingCharacters(in: CharacterSet(charactersIn: "<"))
    }

    var containsOnlyLetters: Bool{
        let letters: CharacterSet = CharacterSet.letters
        return self.rangeOfCharacter(from: letters.inverted) == nil
    }

    func replace(target: String, with: String) -> String {
        replacingOccurrences(of: target, with: with, options: .literal, range: nil)
    }

    func substring(from: Int, to: Int) -> String {
        let fromIndex: Index = index(startIndex, offsetBy: from)
        let toIndex: Index = index(startIndex, offsetBy: to + 1)
        return String(self[fromIndex ..< toIndex])
    }
}
