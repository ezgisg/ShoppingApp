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
    
    case error
    case unknownError
    case ok = "generic.okay"
    case abort = "generic.abort"
    case home
    case categories
    case basket
    case favorites
    case appName
    
    case email
    case password
    case passwordConfirm
    case name
    case surname
    case emailWarning
    
    case searchCategories
    case allCategories
    
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
    
    public enum CampaignMessages: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
        
        case CampaignMessages1 = "CampaignMessages.1"
        case CampaignMessages2 = "CampaignMessages.2"
        case CampaignMessages3 = "CampaignMessages.3"
        case CampaignMessages4 = "CampaignMessages.4"
        case CampaignMessages5 = "CampaignMessages.5"
        case CampaignMessages6 = "CampaignMessages.6"
    
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
