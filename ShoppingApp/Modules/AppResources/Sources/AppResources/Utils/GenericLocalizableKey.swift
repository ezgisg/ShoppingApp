//
//  File.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 23.07.2024.
//

import Foundation

// MARK: - Typealias
public typealias L10nGeneric = GenericLocalizableKey

// MARK: - GenericLocalizableKey
public enum GenericLocalizableKey: String, LocalizableProtocol {
    // MARK: - RawValue
    public var stringValue: String {
        return rawValue
    }

    // MARK: - Keys
    /// Tamam
    case ok = "generic.okay"
    /// Vazgeç
    case abort = "generic.abort"
    /// Anasayfa
    case home
    ///  Kategoriler
    case categories
    /// Sepetim
    case basket
    ///  Favorilerim
    case favorites
    /// App ismi
    case appName
    case email
    case password
    case passwordConfirm
    case name
    case surname
    case emailWarning
    
    public enum PasswordControlMessages: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }

        case number = "PasswordControlMessages.number"
        case letter = "PasswordControlMessages.letter"
        case special = "PasswordControlMessages.special"
        case consecutive = "PasswordControlMessages.consecutive"
        case repeating = "PasswordControlMessages.repeating"
        case minCharacter = "PasswordControlMessages.minCharacter"
        case maxCharacter = "PasswordControlMessages.maxCharacter"
        case nameContain = "PasswordControlMessages.nameContain"
        case surnameContain = "PasswordControlMessages.surnameContain"
    }
}

// MARK: - Functions
extension LocalizableProtocol {
    public func localized() -> String {
        return stringValue.localized()
    }

    public func localizedFormat(arguments: CVarArg...) -> String {
        return stringValue.localizedFormat(arguments: arguments, in: AppResources.bundle)
    }

    public func localizedPlural(argument: CVarArg) -> String {
        return stringValue.localizedPlural(argument: argument, in: AppResources.bundle)
    }
}
