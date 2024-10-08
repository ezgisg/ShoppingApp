//
//  SignInLocalizableKey.swift
//
//
//  Created by Ezgi Sümer Günaydın on 23.07.2024.
//

import Foundation
import AppResources

// MARK: - Typealias
public typealias L10nSignIn = SignInLocalizableKey

// MARK: - SignInLocalizableKey
public enum SignInLocalizableKey: String, LocalizableProtocol {
    // MARK: - RawValue
    public var stringValue: String {
        return rawValue
    }
    
    case signIn
    case register
    case registerMessage
    case forgetPassword
    case haveAccount
    case passwordWarning
   
    // MARK: - SignInOnboarding
    public enum SignInOnboarding: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }

        case title = "SignInOnboarding.title"
        case message = "SignInOnboarding.message"
    }
    
    public enum PrivacyPolicy: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }

        case title = "PrivacyPolicy.title"
        case longTitle = "PrivacyPolicy.longTitle"
        case description = "PrivacyPolicy.description"
    }
    
    public enum MembershipAgreement: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }

        case title = "MembershipAgreement.title"
        case longTitle = "MembershipAgreement.longTitle"
        case description = "MembershipAgreement.description"
    }
}

// MARK: - LocalizableProtocol
extension LocalizableProtocol {
    public func localized() -> String {
        let bundle = stringValue.localized(in: Bundle.module) == stringValue ? AppResources.bundle : Bundle.module
        return stringValue.localized(in: bundle)
    }
}
