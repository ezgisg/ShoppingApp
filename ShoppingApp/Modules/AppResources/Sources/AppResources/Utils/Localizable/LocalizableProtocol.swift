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
    func localized() -> String

}

// MARK: - Functions
public extension LocalizableProtocol {
    func localized(in bundle: Bundle? = AppResources.bundle) -> String {
        return self.stringValue.localized(in: bundle)
    }
}
