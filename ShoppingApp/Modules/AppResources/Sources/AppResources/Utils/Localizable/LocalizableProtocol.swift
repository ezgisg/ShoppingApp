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
    
    func localized() -> String
    func localizedFormat(arguments: CVarArg...) -> String
    func localizedPlural(argument: CVarArg) -> String
}

// MARK: - Functions
public extension LocalizableProtocol {
    func localized() -> String {
        return stringValue.localized()
    }
    
    func localizedFormat(arguments: CVarArg...) -> String {
        return stringValue.localizedFormat(arguments: arguments)
    }
    
    func localizedPlural(argument: CVarArg) -> String {
        return stringValue.localizedPlural(argument: argument)
    }
}
