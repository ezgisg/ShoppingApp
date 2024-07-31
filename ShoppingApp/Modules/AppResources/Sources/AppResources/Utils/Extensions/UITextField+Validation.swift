//
// TextField+Validation.swift
//
//
//  Created by Ezgi Sümer Günaydın on 31.07.2024.
//

import Foundation
import UIKit

// MARK: - TextField Validations
public extension UITextField {
    func isValidLength(
        range: NSRange,
        string: String,
        maxLength: Int
    ) -> Bool {
        guard let textFieldText = self.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                  return false
              }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= maxLength
    }


    /// Take the textField properties and allowed only letters and spaces between names.
    /// - Parameters:
    ///   - range: Range of the character on text.
    ///   - string: Text filed's text
    ///   - maxLength: Determined max range of text.
    /// - Returns: A boolean value for the "shouldChangeCharactersIn" method.
    func isOnlyLettersWithValidSpaces(
        range: NSRange,
        string: String,
        maxLength: Int
    ) -> Bool {
        if range.location == 0 && string == " " { /// prevents space on first character
            return false
        }

        if self.text?.last != " " && string == " " { /// allows only single space
            return true
        }

        if string.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
            return false
        }

        return self.isValidLength(range: range, string: string, maxLength: maxLength)
    }

    /// Take the textField properties and allowed only numbers whitout spaces.
    /// - Parameters:
    ///   - range: Range of the character on text.
    ///   - string: Text filed's text
    ///   - maxLength: Determined max range of text.
    /// - Returns: A boolean value for the "shouldChangeCharactersIn" method.
    func isOnlyNumbersWithNoSpaces(
        range: NSRange,
        string: String,
        maxLength: Int
    ) -> Bool {
        if range.location == 0 && string == " " { /// prevents space on first character
            return false
        }

        if string == " " { /// not allowed spaces
            return false
        }

        if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
            return false
        }

        return self.isValidLength(range: range, string: string, maxLength: maxLength)
    }

    /// Take the textField properties and allowed only spaces between names.
    /// - Parameters:
    ///   - range: Range of the character on text.
    ///   - string: Text filed's text
    ///   - maxLength: Determined max range of text.
    /// - Returns: A boolean value for the "shouldChangeCharactersIn" method.
    func isWithValidSpaces(
        range: NSRange,
        string: String,
        maxLength: Int
    ) -> Bool {
        if range.location == 0 && string == " " { /// prevent space on first character
            return false
        }

        if self.text?.last == " " && string == " " { /// allowed only single space
            return false
        }

        return self.isValidLength(range: range, string: string, maxLength: maxLength)
    }
}
