//
//  Localize.swift
//  Viper-Movies
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
     Change the current language
     - Parameter language: Desired language.
     */
    open class func setCurrentLanguage(_ language: String) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if selectedLanguage != currentLanguage() {
            UserDefaults.standard.set(selectedLanguage, forKey: CurrentLanguageKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: LanguageChangeNotification),
                object: nil
            )
        }
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

    /**
     Resets the current language to the default
     */
    open class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }

    /**
     Get the current language's display name for a language.
     - Parameter language: Desired language.
     - Returns: The localized string.
     */
    open class func displayNameForLanguage(_ language: String) -> String {
        let locale = NSLocale(localeIdentifier: currentLanguage())
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
            return displayName
        }
        return String()
    }
}


