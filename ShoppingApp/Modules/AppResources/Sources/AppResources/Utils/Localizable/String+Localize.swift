//
//  String+Localize.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 16.07.2024.
//

import Foundation

public extension String {
    func localized(in bundle: Bundle? = AppResources.bundle) -> String {
        return localized(using: nil, in: bundle)
    }

    func localizedFormat(arguments: CVarArg..., in bundle: Bundle? = AppResources.bundle) -> String {
        return String(format: localized(in: bundle), arguments: arguments)
    }

    func localizedPlural(argument: CVarArg, in bundle: Bundle? = AppResources.bundle) -> String {
        return NSString.localizedStringWithFormat(localized(in: bundle) as NSString, argument) as String
    }
}

public extension String {
    static func localized(_ key: LocalizableProtocol, in bundle: Bundle? = AppResources.bundle) -> String {
        return key.stringValue.localized(in: bundle)
    }

    static func localizedFormat(_ key: LocalizableProtocol, arguments: CVarArg..., in bundle: Bundle? = AppResources.bundle) -> String {
        return key.stringValue.localizedFormat(arguments: arguments, in: bundle)
    }

    static func localizedPlural(_ key: LocalizableProtocol, argument: CVarArg, in bundle: Bundle? = AppResources.bundle) -> String {
        return key.stringValue.localizedPlural(argument: argument, in: bundle)
    }
}

public extension String {
    func localized(using tableName: String?, in bundle: Bundle? = AppResources.bundle) -> String {
        let bundle: Bundle = bundle ?? .main
        if let path = bundle.path(forResource: Localize.currentLanguage(), ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        } else if let path = bundle.path(forResource: BaseBundle, ofType: "lproj"),
                let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        }
        return self
    }

    func localizedFormat(arguments: CVarArg..., using tableName: String?, in bundle: Bundle? = AppResources.bundle) -> String {
        return String(format: localized(using: tableName, in: bundle), arguments: arguments)
    }

    func localizedPlural(argument: CVarArg, using tableName: String?, in bundle: Bundle? = AppResources.bundle) -> String {
        return NSString.localizedStringWithFormat(
            localized(using: tableName, in: bundle) as NSString, argument
        ) as String
    }
}
