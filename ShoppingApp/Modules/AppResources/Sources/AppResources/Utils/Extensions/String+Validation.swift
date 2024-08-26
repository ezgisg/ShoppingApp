//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 31.07.2024.
//

import Foundation
import UIKit

public extension String {
    var containsOnlyDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
    }

    var containsOnlyLetters: Bool {
        let notLetters = NSCharacterSet.letters.inverted
        return rangeOfCharacter(from: notLetters, options: String.CompareOptions.literal, range: nil) == nil
    }

    var isAlphanumeric: Bool {
        !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }

    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    var isValidURLString: Bool {
        guard let url = URL(string: self) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    var isWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }

    var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }
    
    var hasSpecialCharacters: Bool {
         let specialCharacters = CharacterSet.punctuationCharacters.union(.symbols)
         return rangeOfCharacter(from: specialCharacters) != nil
     }

    var isAlphabetic: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }

    var isValidUrl: Bool {
        return URL(string: self) != nil
    }
    
    
    var hasConsecutiveDigits: Bool {
        let detectedCount = self.count - 2
        guard detectedCount > 0 else { return false }

        for index in 0..<detectedCount {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: 2)
            let substring = self[startIndex...endIndex]

            let digits = substring.compactMap { $0.wholeNumberValue }

            if digits.count == 3 &&
               (digits[0] + 1 == digits[1] && digits[1] + 1 == digits[2] ||
               digits[0] - 1 == digits[1] && digits[1] - 1 == digits[2]) {
                return true
            }
        }
        return false
    }
    
    var hasRepeatingDigits: Bool {
        var repeatCount = 0
        var lastCharacter: Character?

        for character in self {
            if let last = lastCharacter,
               character.isNumber,
               character == last {
                repeatCount += 1
                if repeatCount >= 2 {
                    return true
                }
            } else {
                repeatCount = 0
            }

            lastCharacter = character
        }
        return false
    }
    
    var trimming: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var withoutSpaces: String {
         return self.replacingOccurrences(of: " ", with: "")
     }
    
   
}
