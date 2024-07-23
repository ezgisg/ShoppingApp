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
    /// Kaydol
    case register = "generic.register"
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
