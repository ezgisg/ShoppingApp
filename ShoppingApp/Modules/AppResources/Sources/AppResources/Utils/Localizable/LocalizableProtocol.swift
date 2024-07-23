//
//  LocalizableProtocol.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 16.07.2024.
//

import Foundation

// MARK: - LocalizableProtocol
public protocol LocalizableProtocol {
    var stringValue: String { get }
    
    func localized(in bundle: Bundle?) -> String
    func localizedFormat(arguments: CVarArg..., in bundle: Bundle?) -> String
    func localizedPlural(argument: CVarArg, in bundle: Bundle?) -> String
    
    func localized() -> String
    func localizedFormat(arguments: CVarArg...) -> String
    func localizedPlural(argument: CVarArg) -> String
}

// MARK: - Functions
public extension LocalizableProtocol {
    func localized(in bundle: Bundle? = AppResources.bundle) -> String {
        return self.stringValue.localized(in: bundle)
    }

    func localizedFormat(arguments: CVarArg..., in bundle: Bundle? = AppResources.bundle) -> String {
        return self.stringValue.localizedFormat(arguments: arguments, in: bundle)
    }

    func localizedPlural(argument: CVarArg, in bundle: Bundle? = AppResources.bundle) -> String {
        return self.stringValue.localizedPlural(argument: argument, in: bundle)
    }
}
