//
//  OnboardingLocalizableKey.swift
//
//
//  Created by Ezgi Sümer Günaydın on 26.07.2024.
//

import Foundation
import AppResources

// MARK: - Typealias
public typealias L10nOnboarding = OnboardingLocalizableKey

// MARK: - OnboardingLocalizableKey
public enum OnboardingLocalizableKey: String, LocalizableProtocol {
    // MARK: - RawValue
    public var stringValue: String {
        return rawValue
    }
    
    case skip
    case next
    case letsStart
   
    // MARK: - OnboardingTitleMessage
    public enum OnboardingTitleMessage: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }

        case first = "OnboardingTitleMessage.first"
        case second = "OnboardingTitleMessage.second"
        case third = "OnboardingTitleMessage.third"
    }
    
    // MARK: - OnboardingDetailMessage
    public enum OnboardingDetailMessage: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }

        case first = "OnboardingDetailMessage.first"
        case second = "OnboardingDetailMessage.second"
        case third = "OnboardingDetailMessage.third"
    }
    
    // MARK: - NoConnection
    public enum NoConnection: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }

        case title = "NoConnection.title"
        case message = "NoConnection.message"
        case tryAgain = "NoConnection.tryAgain"
    }
}

// MARK: - LocalizableProtocol
extension LocalizableProtocol {
    public func localized() -> String {
        let bundle = stringValue.localized(in: Bundle.module) == stringValue ? AppResources.bundle : Bundle.module
        return stringValue.localized(in: bundle)
    }

    public func localizedFormat(arguments: CVarArg...) -> String {
        return stringValue.localizedFormat(arguments: arguments, in: Bundle.module)
    }

    public func localizedPlural(argument: CVarArg) -> String {
        return stringValue.localizedPlural(argument: argument, in: Bundle.module)
    }
}
