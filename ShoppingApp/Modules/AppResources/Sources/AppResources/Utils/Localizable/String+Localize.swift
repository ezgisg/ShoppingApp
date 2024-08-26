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
}

public extension String {
    static func localized(_ key: LocalizableProtocol, in bundle: Bundle? = AppResources.bundle) -> String {
        return key.stringValue.localized(in: bundle)
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
}
