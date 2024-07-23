//
//  LocalizableKeys.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 16.07.2024.
//

import Foundation


public typealias L10n = LocalizableKey

// MARK: - LocalizableKey

public enum LocalizableKey: String, LocalizableProtocol {
    
    // MARK: - RawValue
    public var stringValue: String {
        return rawValue
    }
    
    case signIn
    case register
    case forgetPassword
    case email
    case password
    case haveAccount
    
   
    public enum SignInOnboarding: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }

        case title = "SignInOnboarding.title"
        case message = "SignInOnboarding.message"
   
    }
}
