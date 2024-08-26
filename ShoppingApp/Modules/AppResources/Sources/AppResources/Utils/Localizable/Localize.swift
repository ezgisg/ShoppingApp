//
//  Localize.swift
//
//
//  Created by Ezgi Sümer Günaydın on 16.07.2024.
//

import Foundation

import Foundation

///  current language key
public let CurrentLanguageKey = "CurrentLanguageKey"

/// Default language. English. If English is unavailable defaults to base localization.
public let DefaultLanguage = "tr"

/// Base bundle as fallback.
public let BaseBundle = "Base"

/// Name for language change notification
public let LanguageChangeNotification = "LanguageChangeNotification"

// MARK: - Language Setting Functions
open class Localize: NSObject {
    /**
     List available languages
     - Returns: Array of available languages.
     */
    open class func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        // If excludeBase = true, don't include "Base" in available languages
        if let indexOfBase = availableLanguages.firstIndex(of: "Base"), excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }

    /**
     Current language
     - Returns: The current language. String.
     */
    open class func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: CurrentLanguageKey) as? String {
            return currentLanguage
        }
        return defaultLanguage()
    }

    /**
     Default language
     - Returns: The app's default language. String.
     */
    open class func defaultLanguage() -> String {
        var defaultLanguage = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return DefaultLanguage
        }
        let availableLanguages: [String] = self.availableLanguages()
        if availableLanguages.contains(preferredLanguage) {
            defaultLanguage = preferredLanguage
        } else {
            defaultLanguage = DefaultLanguage
        }
        return defaultLanguage
    }

}


